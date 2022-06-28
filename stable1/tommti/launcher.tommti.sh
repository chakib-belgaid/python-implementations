
min=2 
max=120
step=20

implementations=( python3 \
intelpython2 \
python2 \
graalpython \
intelpython3 \
jython \
pypy2 \
activepython \
micropython \
nuitka \
pypy3 \
ipy \
shedskin \
numba3 \
numba2 \
)

    functions=( \
    intArithmetic
    )
j=0
i=1 
j=$((0))
tag="tommti"
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
        