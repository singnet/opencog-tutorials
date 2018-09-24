# Jupyter notebooks for various Opencog libraries

This repository holds various tutorials written in jupyter notebooks for various software repositories under the opencog organization. 

Currently we have them here under one github repository, till the time comes when we have to move them to their corresponding repositories under their code base. 


## Usage examples
### Native installation
https://wiki.opencog.org/w/Building_OpenCog
TODO 
### Using Docker
It's also possible to use docker to experiment with these tutorials. Be sure to install [docker](https://docs.docker.com/install) and [docker-compose](https://docs.docker.com/compose/install/). And the follow the steps outlined below to get them running.
First clone the repositories that you would like to experiment with 
```
git clone https://github.com/opencog/opencog.git
git clone https://github.com/opencog/atomspace.git
git clone https://github.com/opencog/cogutils.git
```

Add to your bashrc file the location of the cloned repositories above.
```
export OPENCOG_SOURCE_DIR=$HOME/path/to/opencog
export ATOMSPACE_SOURCE_DIR=$HOME/path/to/atomspace
export COGUTIL_SOURCE_DIR=$HOME/path/to/cogutil
```
Note since we are going to install it inside opencog. 
```
git clone https://github.com/opencog/docker.git
cd docker/opencog
./docker-build -j

```
Then clone this repository in your prefered location. 
```
git clone https://github.com/singnet/opencog-tutorials.git
```
Add to your bashrc configuration the location of the above file as in following line. 
```
export OPENCOG_NOTEBOOKS=$HOME/path/to/opencog-tutorials
```
To run: 
```
docker-compose -f opencog-jupyter.yml run --service-ports notes
```
## OpenCog tutorials
This set of tutorials describe various libraries or functions that are done using [opencog](https://github.com/opencog/opencog/)
A set of notebook tutorials that describe various libraries or functions that are done using [opencog]
### GHOST tutorials
* [Ghost](opencog_tutorials/GHOST/ghost-tutorial.ipynb)
### Testing Notebook tutorials
Each tutorial (ipynb) file is associted with a text file with the same name, this is to test the expected output of each command against their actual output. To do this you can change the path and file name at the top of the Expect.scm (tester) file and load Expect.scm into guile. This will give you the number of passing and failing commands in that text file. 

