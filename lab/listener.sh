
name=$1

warmup='--++'
mainloop='++--'
begintime=`date +%s`
# collectionname="testcases"`cat machinename`
while read line
do
    prefix=${line:0:4} 
    if [  "$prefix" == "$warmup" ] ; then 
    warmuptime=`date +%s` ; 
    elif [  "$prefix" == "$mainloop" ] ; then 
    executiontime=`date +%s` ; 
    fi
done < "/dev/stdin"
endtime=`date +%s`
echo "++++begin---"$begintime
echo '--++beginwarmup---'$warmuptime
echo '++--endwarmup---'$executiontime
echo "++++end---"$endtime ;



# `python logger.sh.py $name $begintime $warmuptime $executiontime $endtime $collectionname`