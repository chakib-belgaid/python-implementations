
min=2 
max=120
step=20
sleepTime=120s

implementations=( nuitka \
micropython \
cython2 \
jython \
cython3 \
graalpython \
ipy \
numba2 \
pypy3 \
pypy2 \
numba3 \
activepython \
intelpython3 \
intelpython2 \
python2 \
python3 \
)

    functions=( \
    2
    )
j=0
i=1 
j=$((0))
tag="binarytrees"
# while true ; 
# do 
for function in "${functions[@]}" ;   
    do 
        j=$((0))
        while [ $j -lt 100 ] ; 
        do 
    for implem in ${implementations[@]};
            do
                sleep $sleepTime 
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

# shutdown
        