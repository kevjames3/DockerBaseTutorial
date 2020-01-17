# Docker Base Image Example

Goal of this code is to demonstrate how to optimize base image building with docker.  When using CI/CD, most instances that will be running in fresh containers with no cached images and will need to rebuild and redownload images.  We can see this with the file `Dockerfile_all`, which is a simple Node webapp.  In this file, it...
1. Downloads `node:12-alpine` as a base image
1. Set's up the working env while copying over `main.js` and `package.json`
1. Installs dependencies
1. Run's node

The key thing is that as a developer, I will mostly be doing work with my `*.js` files, while not managing my dependencies (for maven, this is usually a `pom.xml`, JS is a `package.json`, etc) as often.

So, instead, what if we separated out the build process?  In this case, make a base image with the image version key-ed off of the library file (in this example, `package.json`), build the base image and push up to a Docker repository.  Then, source the base image and build the rest?  The relevant files are as follows:

1. `build_base_child_image.sh` demonstrates the build logic
1. `Dockerfile_base` builds the base code
1. `Dockerfile_child` builds the remainder of the code 

The key part is that if you change and commit a change to `package.json`, it will rebuild the base image

## Getting Started with the Example

Have [Docker installed](https://docs.docker.com/install/) and verify the command line works.

To run the benchmark to see the trade-off.

```sh
./benchmark.sh
```

If you would like to run the commands separately, do the following:
```sh
# Build Full Image (slow)
isid=`whoami`
docker build -t ${isid}/docker_base_all -f ./Dockerfile_all . 

# Build Base, then child (slow at first, then faster as it won't rebuild base.  If you want to retrigger the base build, simply make a change to package.json and commit)
./build_base_child_image.sh
```

## Verify The Containers

Start up the container:
```sh
isid=`whoami`
docker run -p 8000:80 -d ${isid}/docker_example_child:latest #Go to http://localhost:8000.  
docker run -p 8001:80 -d ${isid}/docker_base_all:latest #Go to http://localhost:8001.  
```

```sh
curl localhost:8000 #Result from docker_example_child:latest
echo "" #cause we need a newline
curl localhost:8001 #Result from docker_base_all:latest
```

Why are we not running `${isid}/docker_example_node_base`?  Because if you look at the files, there is no entry point.