# Proxy download test
A simple jar that downloads webpages and a script executing it to test the functionality and stability of [this](https://hub.docker.com/r/klibio/io.klib.tinyproxy) proxy service inside of a Docker container.

## Jar usage
Pass the url of the webpage you want to download to the jar in a shell.
```bash
$ java -jar io.klib.netconnect-0.1.0-SNAPSHOT.jar <https://www.example.net>
```

## Script usage
Execute the script in a shell with sudo privleges, otherwise docker won't work.
```bash
$ sudo ./test.sh
```

## Explanation

The script will check if a proxy in a Docker container already exists and remove it. Then it uses the jar to repeatedly download working/faulty HTTP and HTTPS webpages. After that it proceeds to start a proxy service inside of a Docker container and repeat the download test over the proxy. In the end it kills the Docker container.

The script exits if a proxy is already defined on os level.