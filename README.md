# ELK-sandbox
ELK 
network visibility 
network observability
cyber threat intelligence CTI 
digital forensics incident responces DFIR

Travis (.com)  branch:  
[![Build Status](https://travis-ci.com/githubfoam/ELK-sandbox.svg?branch=master)](https://travis-ci.com/githubfoam/ELK-sandbox) 

Travis (.com) feature_topology branch:  
[![Build Status](https://travis-ci.com/githubfoam/ELK-sandbox.svg?branch=feature_topology)](https://travis-ci.com/githubfoam/ELK-sandbox) 

~~~~
del Vagrantfile
vagrant init --template Vagrantfile.provision.ansible 
vagrant up --provider=libvirt "vg-compute-06"

vagrant up  vg-docker-01

https://www.elastic.co/what-is/elk-stack
~~~~
~~~~
"bento/centos-stream-8"

del Vagrantfile
vagrant init --template Vagrantfile.erb 

vagrant up  vg-docker-04
vagrant destroy -f  vg-docker-04

vagrant port vg-docker-04
The forwarded ports for the machine are listed below. Please note that
these values may differ from values configured in the Vagrantfile if the
provider supports automatic port collision detection and resolution.

  9200 (guest) => 9200 (host)
  5601 (guest) => 5601 (host)
    22 (guest) => 2200 (host)

>vagrant ssh vg-docker-04

1st instance

cd /vagrant/dockerfiles/1/
docker build -t jenkins-casc:0.2 .

$ docker image ls
REPOSITORY        TAG         IMAGE ID       CREATED        SIZE
jenkins-casc      0.2         85c7072cfd55   22 hours ago   761MB
jenkins/jenkins   lts-jdk11   ea470c80c15d   12 days ago    680MB

docker run -d --rm --name jenkins-casc-p8081 -p 8081:8080 jenkins-casc:0.2

docker container ls
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                                                  NAMES
8ba0c73b7e87   jenkins-casc:0.2   "/sbin/tini -- /usr/…"   5 seconds ago   Up 4 seconds   50000/tcp, 0.0.0.0:8081->8080/tcp, :::8081->8080/tcp   jenkins-casc-p8081

Browse
http://192.168.20.12:8081

docker container stop jenkins-casc-p8081
docker image rm jenkins-casc:0.2

2nd instance

cd /vagrant/dockerfiles/2/
docker build -t jenkins-casc:0.1 .

 docker image ls
REPOSITORY        TAG         IMAGE ID       CREATED          SIZE
jenkins-casc      0.1         969dd456054e   20 minutes ago   457MB
jenkins-casc      0.2         dabde2b35735   25 minutes ago   684MB
jenkins/jenkins   alpine      c2b60a4a9ed0   5 days ago       376MB
jenkins/jenkins   lts-jdk11   ea470c80c15d   11 days ago      680MB
[vagrant@vg-docker-04 2]$

docker run -d --rm --name jenkins-casc-p8080 -p 8080:8080 jenkins-casc:0.1

Browse
http://192.168.20.12:8080

$ docker container ls
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                                                  NAMES
c641971ebe11   jenkins-casc:0.1   "/sbin/tini -- /usr/…"   2 minutes ago   Up 2 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 50000/tcp   jenkins-casc-p8080
8ba0c73b7e87   jenkins-casc:0.2   "/sbin/tini -- /usr/…"   8 minutes ago   Up 8 minutes   50000/tcp, 0.0.0.0:8081->8080/tcp, :::8081->8080/tcp   jenkins-casc-p8081

~~~~
~~~~
>del Vagrantfile
>vagrant init --template Vagrantfile.provision.bash.erb

>vagrant up  vg-elk-01
~~~~
