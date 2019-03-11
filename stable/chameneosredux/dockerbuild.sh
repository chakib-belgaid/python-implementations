#!/bin/sh

name=$1
networkname=aloha
tag=`pwd` 
tag=${tag##*\/}
tag=${tag##stable}

for i in `ls  | egrep "^$name*.dk"` ;
    do 
    echo "----$i begin"
    echo "building chakibmed/${i%*.dk}:$tag"
    docker build --rm -f $i -t chakibmed/${i%*.dk}:$tag . && \
    docker push chakibmed/${i%*.dk}:$tag &&\
    echo "----$i done"
    echo "#_____________________________#"
    
# if  [ -n "$name" ] ; 
# then 
#    time docker run --rm -it --name $name  chakibmed/icse_$name:$tag  LZ2
# fi 
    done 
    