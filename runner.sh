#! /bin/bash 

getPath() {
    paths=(   
    "python2:/usr/bin/python2"
    "python3:/usr/bin/python3"
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
numba
shedskin
nuitka
cython2
cython3
)


benchs=(
    tommti
    binarytrees
    chameneosredux
)

getbench(){ 
    benchs=(
        'tommti:intArithmetic_0_1'
        'binarytrees:2_0_1'
        'chameneosredux:60000_0_1'
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

while getopts "n:p" o; do
    case "${o}" in
        n)
            name=${OPTARG}
            ;;
        p) 
            prepare=1 
            ;; 
    esac
done

shift $((OPTIND-1))
if [ -z $name ] ; then 
    name=$1
    name=${name#*\/} #exctracting the second part after / separator 
    name=${name/\:/_} # replacing : with _ to avoid conflicts 
    fi;



preparetest() {
    intername=$1
    testname=$2

    ls $testname >/dev/null|| mkdir $testname
    case "$intername" in 
        "micropython") 
            sed 's/import time/import utime/' $testname.py > $testname/$testname.$intername ;;
        "cython2")
            docker run --rm -dt --name "$intername"_compiler chakibmed/$intername:1.0
            docker exec -u root "$intername"_compiler mkdir /$testname && docker exec -u root "$intername"_compiler chown awesome /$testname
            docker cp $testname.py  "$intername"_compiler:/$testname/$testname.py
            docker exec  "$intername"_compiler $intername -3 --embed -o $testname/$testname"_$intername".c /$testname/$testname.py && docker exec  "$intername"_compiler   gcc  -I /usr/include/python2.7 -O3 -o /$testname/$testname".$intername" /$testname/$testname"_$intername".c -lpython2.7 -lm -lutil -ldl 
            docker cp "$intername"_compiler:/$testname/$testname".$intername" $testname/$testname".$intername"
            docker stop "$intername"_compiler ;
            ;;
        "cython3")
            docker run --rm -dt --name "$intername"_compiler chakibmed/$intername:1.0
            docker exec -u root "$intername"_compiler mkdir /$testname && docker exec -u root "$intername"_compiler chown awesome /$testname
            docker cp $testname.py  "$intername"_compiler:/$testname/$testname.py
            docker exec  "$intername"_compiler $intername -3 --embed -o $testname/$testname"_$intername".c /$testname/$testname.py && docker exec  "$intername"_compiler   gcc  -I /usr/include/python3.7m -O3 -o $testname/$testname".$intername" $testname/$testname"_$intername".c -lpython3.7m -lm -lutil -ldl
            docker cp "$intername"_compiler:/$testname/$testname".$intername" $testname/$testname".$intername"
            docker stop "$intername"_compiler ;
            # cython3 -3 --embed -o $testname/$testname"_cython3".c $testname.py && gcc  -I /usr/include/python3.7m -O3 -o $testname/$testname".cython3" $testname/$testname"_cython3".c -lpython3.7m -lm -lutil -ldl && rm -f $testname/$testname"_cython3".c 
            ;;
        "numba")
            sed 's/##lib--//g' $testname.py > $testname/$testname.$intername ;;
        "nuitka") 
            docker run --rm -dt --name "$intername"_compiler chakibmed/"$intername":1.0
            docker exec -u root "$intername"_compiler mkdir /$testname 
            docker exec -u root "$intername"_compiler chown awesome /$testname
            docker cp $testname.py  "$intername"_compiler:/$testname/$testname.py
            docker exec -u root "$intername"_compiler nuitka3 --remove-output -o /$testname/$testname"."$intername  /$testname/$testname.py 
            docker cp "$intername"_compiler:/$testname/$testname"."$intername $testname/$testname"."$intername
            docker stop "$intername"_compiler ;
            ;; 
        "shedskin")
            docker run --rm -dt --name "$intername"_compiler chakibmed/"$intername":1.0
            docker exec -u root "$intername"_compiler mkdir /$testname && docker exec -u root "$intername"_compiler chown awesome /$testname
            docker cp $intername/$testname.$intername.py  "$intername"_compiler:/$testname/$testname.py
            docker exec -w /$testname -u root "$intername"_compiler shedskin -o -g  "$testname".py  && \
            docker exec -w /$testname -u root "$intername"_compiler sed -i 's/LFLAGS=-lgc -lpcre/LFLAGS=-lgc -lpcre -lgccpp/' Makefile && \
            docker exec -w /$testname -u root "$intername"_compiler sed -i  's/CCFLAGS=-O2/CCFLAGS=-O3/' Makefile
            docker exec -w /$testname -u root "$intername"_compiler make 
            docker cp "$intername"_compiler:/$testname/$testname $testname/$testname"."$intername
            docker stop "$intername"_compiler ;


            # shedskin -o -g  $testname"_shedskin.py"  
            # sed -i 's/LFLAGS=-lgc -lpcre/LFLAGS=-lgc -lpcre -lgccpp/' Makefile && \
            # sed -i  's/CCFLAGS=-O2/CCFLAGS=-O3/' Makefile && echo yo 
            # cp $testname"_shedskin" ../$testname/$testname".shedskin"
            # cd ../
            ;; 
        *)
            cp "$testname".py $testname/$testname.$intername ;;
    esac
}

generateDockerfile()
{    intername=$1 
     benchname=$2


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
        (time docker run  -v"$(pwd)":/data --rm -it  chakibmed/$intername:1.0 /data/$benchname/$benchname"."$intername $bench_params 2>> "$benchname"_log.txt  )
        x=$?
        ;; 
    # "shedskin")
        # (time shedskin/$benchname".shedskin" $bench_params 2>"$benchname"_log.txt )
    #    x=$?
    #    ;; 
    *) 
        interpreter=$(getPath $intername)  ||  exit 1  
        (time docker run  -v"$(pwd)":/data --rm -it chakibmed/$intername:1.0 $interpreter /data/$benchname/$benchname.$intername $bench_params 2>>"$benchname"_log.txt )
        x=$?
    ;;
    esac 
    echo $x 
    if [ $x == 0 ] ; then 
        echo "$benchname"Test.md;
        sed   "s/\- \[ \] $intername /\- \[X\] $intername / "  "$benchname"Test.md > tmp.log 
        cat tmp.log >  "$benchname"Test.md 
        rm -f tmp.log
        # echo "- [X] $intername " >> "$benchname"Test.md; 
    # else 
        # echo "- [ ] $intername " >> "$benchname"Test.md; 
    fi 
    
}

inter=$1
benchname=$2 
if [ -z $benchname ] ; then 
    benchname="chameneosredux"
fi;

if [ -z $inter ] ; then 
    # echo "# $benchname" > "$benchname"Test.md; 
    for i in ${interpreters[@]}; do 
    
        # interpreter=$(getPath $i)  ||  exit 1  
    # echo $(getbench "$benchname") 
    # if [ nz- $prepare] then ; 
    #     preparetest $i $benchname
    # fi ;
    # echo "----$interpreter----" >> "$benchname"Test.txt
    # (time $interpreter $benchname/$benchname.$i $(getbench "$benchname") 2>"$benchname"_log.txt ) || echo "error" >> "$benchname"Test.txt 
        test $i $benchname;
    done 
else 
    test $inter $benchname
fi 



