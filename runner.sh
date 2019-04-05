#! /bin/bash 

getPath() {
    paths=(   
    "python2:/usr/bin/python2"
    "python3:/usr/bin/python3"
    "numba2:/usr/bin/python2"
    "numba3:/usr/bin/python3"
    "ipy:ipy"
    "jython:jython"
    "micropython:micropython"
    "pypy2:/usr/bin/pypy"
    "pypy3:/usr/bin/pypy3"
    "graalpython:/usr/bin/graalpython"
    "numba:/opt/anaconda/bin/python"
    "activepython:/opt/ActivePython-3.6/bin/python3.6"
    "intelpython2:/intelPython/intelpython2/bin/python"
    "intelpython3:/intelPython/intelpython3/bin/python"
    "stacklesspython2:/stackless/stackless-2715-export/python",
    "stacklesspython3:/stackless/stackless-372-export/python",
    )

    i=$1 
    for inter in ${paths[@]} ; do 
        key="${inter%%:*}"
        value="${inter##*:}"
        # echo $key  $value
        if [ "$i" == "$key" ] ; then 
            # echo $i $value
            myInterpreter=$value
            echo $value ; 
            return 0
        fi ;
    done;
    return 1 
    
}

interpreters=( 
python2
python3
intelpython2
intelpython3
ipy
jython
activepython
micropython
pypy2
pypy3
graalpython
# numba
shedskin
nuitka
cython2
cython3
numba2 
numba3 
)

# benchs=(
#     tommti
#     binarytrees
#     chameneosredux
#     fannkuchredux
#     fasta
# )

getbench(){ 
    benchs=(
        'tommti:intArithmetic_0_50'
        'binarytrees:2_0_1'
        'chameneosredux:60_0_1'
        'fannkuchredux:10_0_16'
        'fasta:25_0_1'
    )
    benchname=$1 

    for bench in ${benchs[@]} ; do 
        key="${bench%%:*}"
        value="${bench##*:}"
        # echo $key  $value
        if [ "$benchname" == "$key" ] ; then 
            echo "${value//_/ }"; 
            return 0
        fi ;
    done;
    return 1 

}

while getopts "b:n:pd" o; do
    case "${o}" in
        b) 
            benchname=${OPTARG}
            ;;
        n)  
            name=${OPTARG}
            ;;
        p) 
            prepare=1 
            ;; 
        d)
            generatedocker=1
            ;;
    esac
done

shift $((OPTIND-1))
if [ -z $name ] ; then 
    name=$1
    name=${name#*\/} #exctracting the second part after / separator 
    name=${name/\:/_} # replacing : with _ to avoid conflicts 
    fi;



function ispython3 ()
{ py3interpereters=(
'python3'
'intelpython3'
'pypy3'
'cython3'
'nuitka '
'activepython'
'numba'
'numba3'
'micropython'
'graalpython'
)

    for i in ${py3interpereters[@]} ; do 
    # echo $i $intername
        if [[ $i == $intername ]]; then  
            echo $i $intername
            return 0

        fi 
    done 
    
    return 1

}


preparetest() {
    intername=$1
    testname=$2
    dirname=$testname
    # ispy3= $(ispython3 $intername )
    ispython3 && testname=$testname'3'
    # if [ ispython3 ] ; then 
        # testname=$testname'3'
    # fi 
    # echo ${testname%*3}
    # exit 
    echo $testname
    ls sources/$dirname >/dev/null|| mkdir sources/$dirname
    case "$intername" in 
        "micropython") 
            sed 's/time/utime/g' $testname.py > "sources/"$dirname/$dirname"."$intername ;;
        "cython2")
            docker run --rm -dt --name "$intername"_compiler chakibmed/$intername:1.0
            docker exec -u root "$intername"_compiler mkdir /$testname && docker exec -u root "$intername"_compiler chown awesome /$testname
            docker cp $testname.py  "$intername"_compiler:/$testname/$testname.py
            docker exec  "$intername"_compiler $intername -3 --embed -o $testname/$testname"_$intername".c /$testname/$testname.py && docker exec  "$intername"_compiler   gcc  -I /usr/include/python2.7 -O3 -o /$testname/$testname".$intername" /$testname/$testname"_$intername".c -lpython2.7 -lm -lutil -ldl 
            docker cp "$intername"_compiler:/$testname/$testname".$intername" "sources"/$dirname/$dirname"."$intername
            docker stop "$intername"_compiler ;
            # docker rm -f "$intername"_compiler ;
            ;;
        "cython3")
            docker run --rm -dt --name "$intername"_compiler chakibmed/$intername:1.0
            docker exec -u root "$intername"_compiler mkdir /$testname && docker exec -u root "$intername"_compiler chown awesome /$testname
            docker cp $testname.py  "$intername"_compiler:/$testname/$testname.py
            docker exec  "$intername"_compiler $intername -3 --embed -o $testname/$testname"_$intername".c /$testname/$testname.py && docker exec  "$intername"_compiler   gcc  -I /usr/include/python3.7m -O3 -o $testname/$testname".$intername" $testname/$testname"_$intername".c -lpython3.7m -lm -lutil -ldl
            docker cp "$intername"_compiler:/$testname/$testname".$intername" "sources"/$dirname/$dirname"."$intername
            docker stop "$intername"_compiler ;
            # docker rm -f "$intername"_compiler ;
            # cython3 -3 --embed -o $dirname/$testname"_cython3".c $testname.py && gcc  -I /usr/include/python3.7m -O3 -o $dirname/$testname".cython3" $dirname/$testname"_cython3".c -lpython3.7m -lm -lutil -ldl && rm -f $dirname/$testname"_cython3".c 
            ;;
        "numba")
            sed 's/##lib--//g' $testname.py > "sources/"$dirname/$dirname"."$intername ;;
        "nuitka") 
            docker run --rm -dt --name "$intername"_compiler chakibmed/"$intername":1.0
            docker exec -u root "$intername"_compiler mkdir /$testname 
            docker exec -u root "$intername"_compiler chown awesome /$testname
            docker cp $testname.py  "$intername"_compiler:/$testname/$testname.py
            docker exec -u root "$intername"_compiler nuitka3 --remove-output -o /$testname/$testname"."$intername  /$testname/$testname.py 
            docker cp "$intername"_compiler:/$testname/$testname"."$intername "sources/"$dirname/$dirname"."$intername
            docker stop "$intername"_compiler ;
            docker rm -f "$intername"_compiler ;
            
            ;; 
        "shedskin")
            docker run --rm -dt --name "$intername"_compiler chakibmed/"$intername":1.0
            docker exec -u root "$intername"_compiler mkdir /$testname && docker exec -u root "$intername"_compiler chown awesome /$testname
            docker cp $intername/$testname.$intername.py  "$intername"_compiler:/$testname/$testname.py
            docker exec -w /$testname -u root "$intername"_compiler shedskin -o -g  "$testname".py  && \
            docker exec -w /$testname -u root "$intername"_compiler sed -i 's/LFLAGS=-lgc -lpcre/LFLAGS=-lgc -lpcre -lgccpp/' Makefile && \
            docker exec -w /$testname -u root "$intername"_compiler sed -i  's/CCFLAGS=-O2/CCFLAGS=-O3/' Makefile
            docker exec -w /$testname -u root "$intername"_compiler make 
            docker cp "$intername"_compiler:/$testname/$testname "sources/"$dirname/$dirname"."$intername
            # docker stop "$intername"_compiler ;
            # docker rm -f "$intername"_compiler ;


            # shedskin -o -g  $testname"_shedskin.py"  
            # sed -i 's/LFLAGS=-lgc -lpcre/LFLAGS=-lgc -lpcre -lgccpp/' Makefile && \
            # sed -i  's/CCFLAGS=-O2/CCFLAGS=-O3/' Makefile && echo yo 
            # cp $testname"_shedskin" ../$dirname/$testname".shedskin"
            # cd ../
            ;; 
        *)
            cp "$testname".py "sources/"$dirname/$dirname"."$intername ;;
    esac
}


generateTestfile()
{
    echo '# '$benchname > $benchname'Test.md'
    mkdir -p "stable"/$benchname"/pythonfiles" 
    for i in ${interpreters[@]}; do 
        echo '- [ ] '$i >> $benchname'Test.md'
    done 
}

test(){
    intername=$1 
    benchname=$2 
    bench_params=$(getbench "$benchname")

    echo $intername $benchname $bench_params
    if [ "$prepare" != "" ]; then 
        preparetest $intername $benchname;
        
    fi 

    case "$intername" in 
    "nuitka" | "cython2" | "cython3"|"shedskin") 
        (time docker run  -v"$(pwd)":/data --rm -it  chakibmed/$intername:1.0 /data/sources/$benchname/$benchname"."$intername $bench_params 2>> "$benchname".log  )
        x=$?
        ;; 
    # "shedskin")
        # (time shedskin/$benchname".shedskin" $bench_params 2>"$benchname".log )
    #    x=$?
    #    ;; 
    *) 
        interpreter=$(getPath $intername)  ||  exit 1  
        (time docker run  -v"$(pwd)":/data --rm -it chakibmed/$intername:1.0 $interpreter /data/sources/$benchname/$benchname.$intername $bench_params 2>>"$benchname".log )
        x=$?
    ;;
    esac 
    echo $x 
    if [ $x == 0 ] ; then 
        echo "$benchname"Test.md;
        sed   "s/\- \[ \] $intername/\- \[X\] $intername/ "  "$benchname"Test.md > tmp.log 
        cat tmp.log >  "$benchname"Test.md 
        rm -f tmp.log
        cp sources/$benchname/$benchname.$intername "stable"/$benchname/'pythonfiles'/$benchname.$intername 
        # echo "- [X] $intername " >> "$benchname"Test.md; 
    # else 
        # mv "$benchname"/
        # echo "- [ ] $intername " >> "$benchname"Test.md; 
    fi 
    
}

inter=$1
# benchname=$2 
if [ -z $benchname ] ; then 
    benchname="binarytrees"
fi;

if [ "$generatedocker" != "" ]; then 
        # echo yolo
        mkdir -p "stable"/$benchname"/recap" 
        mv "$benchname"Test.md   "stable"/$benchname"/recap"/ 
        mv "$benchname"*.py "stable"/$benchname"/recap"/
        python generator.py $benchname $(getbench "$benchname")
        rm "$benchname".log
        exit 
fi 

if [ -z $inter ] ; then 
    generateTestfile
    # echo "# $benchname" > "$benchname"Test.md; 
    for i in ${interpreters[@]}; do 
    
        # interpreter=$(getPath $i)  ||  exit 1  
    # echo $(getbench "$benchname") 
    # if [ nz- $prepare] then ; 
    #     preparetest $i $benchname
    # fi ;
    # echo "----$interpreter----" >> "$benchname"Test.txt
    # (time $interpreter $benchname/$benchname.$i $(getbench "$benchname") 2>"$benchname".log ) || echo "error" >> "$benchname"Test.txt 
        test $i $benchname;
        # echo $i $benchname;
    done 

else 
    test $inter $benchname
fi 




