
min=2 
max=120
step=20

implementations=( python3 \
python2 \
activepython \
intelpython3 \
numba3 \
intelpython2 \
numba2 \
ipy \
pypy3 \
pypy2 \
cython3 \
cython2 \
graalpython \
jython \
nuitka \
)

    functions=( \
    25
    )
j=0
i=1 
j=$((0))
tag="fasta"
# while true ; 
# do 
for function in "${functions[@]}" ;   
    do 
        j=$((0))
        while [ $j -lt 100 ] ; 
        do 
    for implem in ${implementations[@]};
            do
                name=$tag"_"$implem"_"$function"_"$i"_"$j
                echo $implem  $function 5 $i  $j ;
                # docker pull chakibmed/icse_$implem:tommtiv1
                tester.sh -n $name chakibmed/$implem:$tag $function 5 $i  ;
                # echo  chakibmed/$implem:$tag $function 5 $i  ;
            done
        j=$((j+1))  
        done
    done

    # i=$((i + 10 ))
# done 

shutdown
        