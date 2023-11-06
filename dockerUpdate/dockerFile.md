`docker image pull redis`
docker image ls
docker image ls --digests
docker system info
 
sudo ls -al /var/lib/docker/overlay2 		- used to check the layers for docker images
 
 
docker ps -a 					- used to list all the running containers
docker images					- used to list all the images
docker image inspect redis:latest		- used to inspect the images
 
docker diff {CONTAINER_ID_OR_NAME}		- used to access the diff files 
docker history redis:latest			- used to check image history
 
mkdir /tmp/image-layers				- used to create tmp dir
docker save -o /tmp/image.tar redis:latest	- used to create a tarball of image
tar -xf /tmp/image.tar -C /tmp/image-layers	- extract content of tarball and cp to image-layer
cd /tmp/image-layers				- change directory to image-layer
ls -al						- list diff content
 
docker image rm redis				- delete image
sudo nano Dockerfile				- create Dockerfile
sudo nano package.json				- create package.json file
docker image build -t ceydenApp .		- build image from Dockerfile
sudo nano app.js				- create app.js file
docker container run -d --name ceyden -p 8080:8080 ceydenapp	- create a container
 
docker image build https://github.com/nigelpoulton/psweb.git	- build docker image from git 
docker container run -d --name ceyden -p 8080:8080 35ee63c2cbff	- build container from image tag
 
docker stop <container_id>			- stop container
docker rm <container_id>			- remove container
 
 
 
 
****************package.json*********************
 
{
  "name": "ceyden-app",
  "version": "1.0.0",
  "description": "sample docker app",
  "main": "app.js",
  "dependencies": {
    "express": "^4.17.1"
  },
  "scripts": {
    "start": "node app.js"
  },
  "author": "Dennis",
  "license": "MIT"
}
 
 
****************app.js********************
 
const http = require('http');
 
const hostname = '0.0.0.0';
const port = 8080;
 
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello ladies and gentlemen, welcome to our new site. This site was built by a container running on Docker!\n');
});
 
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
 
 
 
 
***********Dockerfile******************
 
From alpine
 
LABEL maintainer="dennis@ceyden.com"
 
RUN apk add --update nodejs npm
 
COPY . /src
 
WORKDIR /src
 
RUN npm install
 
EXPOSE 8080
 
ENTRYPOINT ["node", "./app.js"]
