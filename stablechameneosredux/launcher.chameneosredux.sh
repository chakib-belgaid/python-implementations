
min=2 
max=120
step=20

implementations=( python3 \
python2 \
cython3 \
nuitka \
activepython \
cython2 \
pypy3 \
numba \
pypy2 \
micropython \
intelpython2 \
intelpython3 \
)

    functions=( \
    60
    )
j=0
i=1 
j=$((0))
tag="chameneosredux"
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
        