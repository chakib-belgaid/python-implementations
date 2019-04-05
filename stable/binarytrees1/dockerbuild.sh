#!/bin/sh

name=$1
networkname=aloha
tag=`pwd` 
tag=${tag##*\/}
tag=${tag##stable}

if [[ -z $name ]]; then 

    for i in `ls  | egrep ".*.dk"` ;
    do 
        echo "----$i begin"
        echo "building chakibmed/${i%*.dk}:$tag"
        docker build --rm -f $i -t chakibmed/${i%*.dk}:$tag . && \
        docker push chakibmed/${i%*.dk}:$tag &&\
        echo "----$i done"
        echo "#_____________________________#"
    done 
 
else 
    for i in `ls  | egrep "^$name*.dk"` ; do 
        echo "----$i begin"
        echo "building chakibmed/${i%*.dk}:$tag"
        docker build --rm -f $i -t chakibmed/${i%*.dk}:$tag . && \
        docker push chakibmed/${i%*.dk}:$tag &&\
        echo "----$i done"
        echo "#_____________________________#"
    done 
fi     
