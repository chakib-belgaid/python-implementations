min=2
max=120
step=20

implementations=(
    stacklesspython2
    stacklesspython3
    intelpython2
    intelpython3
    activepython
    cython2
    cython3
    graalpython
    ipy
    jython
    micropython
    nuitka
    numba2
    numba3
    pypy2
    pypy3
    python2
    python3
    shedskin
)

functions=(
    # intArithmetic
    # doubleArithmetic
    # longArithmetic
    # trig
    # array
    # hashtest
    hashes
    # heapsort
    # vector
    # matrixMultiply
    # nestedLoop
    # stringConcat
    # io
    #  except \
)

function launchsensor()
{  
    docker run --privileged --name $1 -td  \
    -v /sys:/sys -v /tmp/docker/containers:/var/lib/docker/containers:ro \
    -v /tmp/reporting:/reporting \
    powerapi/hwpc-sensor:0.1.1 \
    powerapi:0.1.1 \
    -n "$(hostname -f)" \
    -f 100 \
    -r "csv" -U "/reporting" \
    -s "rapl" -o -e "RAPL_ENERGY_PKG" -e "RAPL_ENERGY_DRAM" 
}



# function=intArithmetic
# i=20

j=0
i=5
j=$((0))
tag="tommti"
# while true ;
# do
for implem in ${implementations[@]}; do
    docker pull chakibmed/$implem:$tag
done

for function in ${functions[@]}; do
    sensor="sensor-"$function  

    launchsensor $sensor


    sleep 5s ; 
    echo "benchmark" >>times_"$function"_"$i".csv
    j=$((0))
    while [ $j -lt 100 ]; do
        for implem in ${implementations[@]}; do
            name=$tag"_"$implem"_"$function"_"$i"_"$j
            echo $implem $function 5 $i $j
            echo $name >>times_"$function"_"$i".csv
            # docker pull chakibmed/icse_$implem:tommtiv1
            docker run --rm -it --name $name chakibmed/$implem:$tag $function 1 $i >>times_"$function"_"$i".csv
            # echo  chakibmed/$implem:$tag $function 5 $i  ;
        done
        j=$((j + 1))
    done
    sleep 5s ; 
    docker stop  $sensor
done

# i=$((i + 10 ))
# done

