
warmup=1
mainloop=2
stepcounter=0
program=$@

#docker exec -it tesi ./launcher.sh python dijkstra2

while true ; 
do 
    i=0
    mainloop=$((warmup*2)) 
    #our timer if the time exceed 200 sec we stop the program 
    sleep 200 &
    timer=$! 
    `$program $warmup 0 | ./listener.sh | ./calculator.sh  > tempo && kill $timer ` &  # launch the program and stores  warmup and exection time in a temporary file tempo - if it ends well we kill the timeout 
    wait $timer # wait for the end of the timer or the program 
    res=`cat tempo`
    if  [ -z "$res"  ] 
    then 
        echo ' timeout  ended ' >&2 
        exit 1 
    fi 
    warmuptime=${res##*warmuptime:}
    warmuptime=${warmuptime%executiontime*}
    executiontime=${res##*executiontime:}
    if [ -z "$warmuptime" ] || [ -z "$executiontime" ] ; then 
        echo ' error in the program ' >&2 
        exit 2 
    fi 
    echo $warmup $warmuptime $executiontime >&2
    `rm -f tempo`
    if [ $warmuptime -gt 120 ] ; 
        then 
        if [ $warmup -gt 8 ] ; then
            warmup=$((warmup/3+1))
        else 
        warmup=$((warmup-1)) 
        fi 
        elif [ $warmuptime -gt 50 ] ; 
            then  
            break; 
        else 
        warmup=$((warmup *2))
        stepcounter=$((stepcounter+1))
        if [ $stepcounter -ge 20 ]; 
            then 
            echo " cant add more that that"
            break ;
            fi
        fi
done 

echo param: $warmup';'$warmuptime';'$executiontime

