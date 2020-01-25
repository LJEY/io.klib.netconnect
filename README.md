# Proxy download test
A simple bash script to test the functionality and stability of a proxy service.

## Usage
Simply go to a command line and execute `sudo ./test.sh` for Linux and `win32.sh` for Windows.

## Explanation

The script will check if a proxy in a Docker container already exists and remove it. Then it uses a java programm to repeatedly download working and faulty HTTP and HTTPS webpages. After that it proceeds to start a proxy service inside of a Docker container and repeat the download test over the proxy. In the end it kills the Docker container.

The script exits if a proxy is already defined on os level.