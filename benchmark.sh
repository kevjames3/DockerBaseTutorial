package_sha=`git log -n 1 --pretty=format:%H -- package.json | awk '{ print $1 }'`
isid=`whoami`
base=${isid}/docker_example_node_base
base_image=${base}:${package_sha}

echo "--------------"
echo "Removing cached images for purposes of benchmarking"
echo "docker rmi -f ${base_image}"
echo "docker rmi -f node:12-alpine"
docker rmi -f ${base_image}
docker rmi -f node:12-alpine
echo "--------------"

echo "--------------"
echo "Building with Base Image, first one will be the longest"
echo "Docker image: ${isid}/docker_example_child:latest"
for i in {5..1}
do
  time ./build_base_child_image.sh > /dev/null
done
echo "--------------"

echo "--------------"
echo "Building with new image every time and no new caches"
echo "Docker image: ${isid}/docker_base_all:latest"
for i in {5..1}
do
  docker rmi -f node:12-alpine > /dev/null
  time docker build -t ${isid}/docker_base_all -f ./Dockerfile_all . --no-cache=true > /dev/null
done
echo "--------------"