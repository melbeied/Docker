# Build a docker image and test service container

## Start
we tag our image with a meaningful name, in this case it's : project3

```shell
    $ docker build -t project3 .
```

output 

```
   ..
   ...
   ....
    Removing intermediate container 5c7a01bb1d5a
    ---> 32b359c7ef79
    Step 14/14 : ENTRYPOINT service ssh restart && nginx -g 'daemon off;'
    ---> Running in 76511dda1d27
    Removing intermediate container 76511dda1d27
    ---> 609cfa1116fb
    Successfully built 609cfa1116fb
    Successfully tagged projet3:latest
```

## Verify image in local repository

```shell
    $ docker images
```

output

```
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    projet3             latest              609cfa1116fb        16 hours ago        359MB
    <none>              <none>              ce53b115a4e9        16 hours ago        131MB
    debian              latest              58075fe9ecce        10 days ago         114MB
```

## Instanciate containner

```shell
    $ docker run -d -p 80:80 -p 2221:22 --name myimage projet3
    $ docker ps

    >> output console

CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                                      NAMES
f118d5a191e8        projet3             "/bin/sh -c 'service…"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, 0.0.0.0:2221->22/tcp   myimage

```

## SSH Access

### From the vm host for your docker container
````
    $ IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myimage`
    $ ssh root@$IP

    or
    
    $ ssh -p 2221 root@$localhost
````
### From the host machine that guest you vagrant vm

suppose you use you forward default ssh port like that 

```ruby
    config.vm.network "forwarded_port", guest: 2221, host: 2221
```
the command to use is :

```shell
    $ ssh -p 2221 root@localhost
```

## Access to Nginx welcome page

### From the vm host for your docker container

```shell
    $ curl localhost
```

### From the host machine that guest you vagrant vm

suppose you forward default http port like that 

```ruby
    config.vm.network "forwarded_port", guest: 80, host: 8080
```
Open your preferred navigator and tape http://localhost:8080 in the bar address