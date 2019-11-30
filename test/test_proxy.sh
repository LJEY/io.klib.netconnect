#!/bin/bash

printf "%s\n" "Checking if a proxy for http is already defined on os levl"

    if [ -z "$http_proxy" ]
    then
        printf "%s\n" "Success, no proxy configured for http"
    else
        printf "%s\n" "Error, there already is a proxy configured for http"
        exit 1
    fi

printf "%s\n" "Checking if a proxy for https is already defined on os levl"

    if [ -z "$https_proxy" ]
    then
        printf "%s\n" "Success, no proxy configured for https"
    else
        printf "%s\n" "Error, there already is a proxy configured for https"
        exit 1
    fi

printf "%s\n" "Testing direct connection for http"

    java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columbia.edu/~fdc/sample.html > output.log 2> error.log

    if [ $? == 0 ]
    then
        printf "%s\n" "Direct connection per http works"
    else
        printf "%s\n" "Direct connection for http didn't work"
        exit 1
    fi

printf "%s\n" "Testing faulty direct connection for http"

    java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columba.edu/~fdc/sample.html > output.log 2> error.log

    if [ $? == 1 ]
    then
        printf "%s\n" "Error code as expected"
    else
        printf "%s\n" "Error code not as expected"
        exit 1
    fi

    printf "%s\n" "Testing direct connection for https"

    java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.heise.de > output.log 2> error.log

        if [ $? == 0 ]
        then
            printf "%s\n" "Direct connection per https works"
        else
        printf "%s\n" "Direct connection for https didn't work"
        exit 1
    fi

printf "%s\n" "Testing faulty direct connection for https"
        
    java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.gooogle.de > output.log 2> error.log

    if [ $? == 1 ]
    then
        printf "%s\n" "Error code as expected"
    else
        printf "%s\n" "Error code not as expected"
        exit 1
    fi

printf "%s\n" "Starting a nginx proxy server in a docker container"

sudo docker run --name temp -d -p 8080:8080 klibio/io.klib.forwarding-ssl-proxy:master-latest

#Configre proxy for java and try to download webpage

#HTTP

AVA_VMARGS="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>" java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columbia.edu/~fdc/sample.html > output.log 2> error.log

if [ $? == 0 ]
then
    echo Success
fi

AVA_VMARGS="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>" java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columba.edu/~fdc/sample.html > output.log 2> error.log

if [ $? == 1 ]
then
    echo Success
fi

#HTTPS -> Echo printf("text") 

#DRY

AVA_VMARGS="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>" java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.heise.de > output.log 2> error.log

if [ $? == 0 ]
then
    echo Success
fi

AVA_VMARGS="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>" java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.gooogle.de > output.log 2> error.log

if [ $? == 1 ]
then
    echo Success
fi

#Set OS wide proxy

export http_proxy=http://127.0.0.1:8080
export https_proxy=http://127.0.0.1:8080

#HTTP

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columbia.edu/~fdc/sample.html > output.log 2> error.log

if [ $? == 0 ]
then
    echo Success
fi

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columba.edu/~fdc/sample.html > output.log 2> error.log

if [ $? == 1 ]
then
    echo Success
fi

#HTTPS

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.heise.de > output.log 2> error.log

if [ $? == 0 ]
then
    echo Success
fi

java -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.gooogle.de > output.log 2> error.log

if [ $? == 1 ]
then
    echo Success
fi

#Delte proxy

sudo docker rm -f temp

printf "%s\n" "Nice, everything works as intended!" 

#Redicrt std out std err
