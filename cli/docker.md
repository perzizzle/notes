To login to repository
docker login docker.artifactory.surescripts.tech

**To build container**
docker build -t $tag $path

**To push a container**
docker push dockerhub.com/foo:1

**To pull an image**
docker pull dockerhub.com/microsoft/windows/dotnet/framework/4.7.2:1.1

**To run container (https://docs.docker.com/engine/reference/commandline/run/)**
docker run -d -p 3000:3000 $tag
d = detach
p = publish container port to host
i = interactive

**To see running containers**
docker ps

**To see logs from a container**
sudo docker logs -f $container_id

**To list all images**
sudo docker images

**To enter a container**
sudo docker exec -it $container_id bash

**Example running commands in container**
`
>git clone repository.git
>sudo docker run -dit -w /workingdirectory -v /local_path:/container_path:rw,z dockerhub.com/container
>sudo docker ps
>sudo docker exec -it 2ae123e3615b bash
>root@2ae123e3615b:# chmod +x gradlew
>root@2ae123e3615b:# ./gradlew build
`
