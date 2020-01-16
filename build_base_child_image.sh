package_sha=`git log -n 1 --pretty=format:%H -- package.json | awk '{ print $1 }'`
repo_sha=`git log -n 1 --pretty=format:%H | awk '{ print $1 }'`
isid=`whoami`
base=${isid}/docker_example_node_base
child=${isid}/docker_example_child
image=${base}-${package_sha}
# This is where you would pull the image, like `docker push ${image}`

images=`docker images -q ${image}`
echo $images
if [ -z $images ]; then
  echo "No image present, building image ${image}."
  echo "docker build -t ${image} -f ./Dockerfile_base ."
  docker build -t ${image} -f ./Dockerfile_base .
  # You can push the file here to the docker repository, see `docker push ${image}`
else 
  echo "Base Image is present"
fi

echo "Building child image"
# Now build the child file
docker build -t ${child}-${repo_sha} -f ./Dockerfile_child . --no-cache=true