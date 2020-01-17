package_sha=`git log -n 1 --pretty=format:%H -- package.json | awk '{ print $1 }'`
isid=`whoami`
base=${isid}/docker_example_node_base
child=${isid}/docker_example_child
base_image=${base}:${package_sha}
# This is where you would pull the base_image, like `docker pull ${base_image}`
echo "-----------------"
echo "Looking for image ${base_image}"
images=`docker images -q ${base_image}`
if [ -z $images ]; then
  echo "No image present, building image ${base_image}."
  echo "docker build -t ${base_image} -f ./Dockerfile_base . --no-cache=true"
  docker build -t ${base_image} -f ./Dockerfile_base .
  # You can push the file here to the docker repository, see `docker push ${base_image}`
else 
  echo "Base Image is present"
fi
echo "-----------------"

echo "Building child image"
echo "docker build -t ${child}:latest -f ./Dockerfile_child . --no-cache=true --build-arg BASEIMAGE=${base_image}"
# Now build the child file
docker build -t ${child}:latest -f ./Dockerfile_child . --no-cache=true --build-arg BASEIMAGE=${base_image}
echo "-----------------"