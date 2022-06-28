
min=2 
max=120
step=20
sleepTime=120s

implementations=( graalpython \
python3 \
python2 \
micropython \
numba2 \
shedskin \
numba3 \
ipy \
activepython \
nuitka \
pypy3 \
intelpython2 \
pypy2 \
jython \
intelpython3 \
cython3 \
cython2 \
)

    functions=( \
    tommti
    )
j=0
i=1 
j=$((0))
tag="benchmark"
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
                docker run --rm -it  --name $name chakibmed/$implem:$tag $function 5 $i  ;
                # echo  chakibmed/$implem:$tag $function 5 $i  ;
            done
        j=$((j+1))  
        done
    done

    # i=$((i + 10 ))
# done 

shutdown
        