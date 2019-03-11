
min=2 
max=120
step=20

implementations=( cython3 \
intelpython3 \
cython2 \
intelpython2 \
nuitka \
pypy3 \
pypy2 \
activepython \
python3 \
numba2 \
python2 \
numba3 \
)

    functions=( \
    10
    )
j=0
i=16 
j=$((0))
tag="fannkuchredux"
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
                ./tester.sh -n $name chakibmed/$implem:$tag $function 5 $i  ;
                # echo  chakibmed/$implem:$tag $function 5 $i  ;
            done
        j=$((j+1))  
        done
    done

    # i=$((i + 10 ))
# done 

shutdown
        