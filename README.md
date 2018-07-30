# Jupyter notebooks for various Opencog libraries

This repository holds various tutorials written in jupyter notebooks for various software repositories under the opencog organization. 

Currently we have them here under one github repository, till the time comes when we have to move them to their corresponding repositories under their code base. 


## Usage examples
### Native installation
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
### GHOST tutorials
* [Ghost](opencog_tutorials/GHOST/ghost-tutorial.ipynb)
