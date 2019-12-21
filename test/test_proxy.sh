#!/bin/bash

#set -u
#set -e


function proxyCheck {
    printf "%s\n" "Checking if a proxy for $1 is already defined on os levl"
    eval var='$'$1_proxy
    echo $var
    if [ -z "$var" ]
    then
        printf "%s\n" "     Success, no proxy configured for $1"
    else
        printf "%s\n" "     Error, there already is a proxy configured for $1"
        exit 1
    fi
}

#proxyCheck http
#proxyCheck https

#JAVA_VMARG="-Dhttp.proxyHost=127.0.0.1 -Dhttp.proxyPort=8080"

export http_proxy=127.0.0.1:8080
export https_proxy=127.0.0.1:8080

java -jar ./../build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.heise.de > output.log 2> error.log

        if [ $? == 0 ]
        then
            printf "%s\n" "     Success, connection per http works"
        else
            printf "%s\n" "     Error, connection for http didn't work"
            exit 1
        fi

exit 0
            
function connectionTest {
    
    
    if [ $1 = http ]
    then
    
        printf "%s\n" "Testing connection for http"
    
        java ${JAVA_VMARGS} -jar ./../build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columbia.edu/~fdc/sample.html > output.log 2> error.log

        if [ $? == 0 ]
        then
            printf "%s\n" "     Success, connection per http works"
        else
            printf "%s\n" "     Error, connection for http didn't work"
            exit 1
        fi
        
        printf "%s\n" "Testing faulty connection for http"
        
        java ${JAVA_VMARGS} -jar ./../build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar http://www.columba.edu/~fdc/sample.html > output.log 2> error.log

        if [ $? == 1 ]
        then
            printf "%s\n" "     Success, system exit code as expected"
        else
            printf "%s\n" "     Error, system exit code not as expected"
            exit 1
        fi
    fi
    if [ $1 = https ]
    then
        
        printf "%s\n" "Testing connection for https"
    
        java ${JAVA_VMARGS} -jar ./../build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.heise.de > output.log 2> error.log

        if [ $? == 0 ]
        then
            printf "%s\n" "     Success, connection per https works"
        else
            printf "%s\n" "     Error, connection for https didn't work"
            exit 1
        fi
        
        printf "%s\n" "Testing faulty connection for https"
        
        java ${JAVA_VMARGS} -jar /home/lukas/klib/io.klib.netconnect/build/libs/io.klib.netconnect-0.1.0-SNAPSHOT.jar https://www.gooogle.de > output.log 2> error.log

        if [ $? == 1 ]
        then
            printf "%s\n" "     Success, system exit code as expected"
        else
            printf "%s\n" "     Error, system exit code not as expected"
            exit 1
        fi
    fi
}
 
printf "%s\n" "Testing direct connection" 
 
connectionTest http 
connectionTest https 

printf "%s\n" "Starting a nginx proxy server in a docker container"

#sudo docker run --name temp -d -p 8080:8080 klibio/io.klib.forwarding-ssl-proxy:master-latest

printf "%s\n" "Configuring proxy for java"

JAVA_VMARG="-Dhttp.proxyHost=<127.0.0.1> -Dhttp.proxyPort=<8080>"

printf "%s\n" "Testing connection with java proxy"  
    
connectionTest http 
connectionTest https 

printf "%s\n" "Setting os wide proxy"

    export http_proxy=127.0.0.1:8080
    export https_proxy=127.0.0.1:8080

printf "%s\n" "Testing connection with os wide proxy"  

connectionTest http 
connectionTest https 

printf "%s\n" "Removing docker container again"

#    sudo docker rm -f temp

printf "%s\n" "Nice, everything works as intended!" 

