# limenv

## Introduction

This package is a fork of 1cosmologist/cmbenv environment written and maintained by Shamik Ghosh.
It contains scripts for installing limenv, an environment for
running extraglactic sky modeling software under development. Currently
configured for running healpy and GPU-enabled jax on Perlmutter at NERSC.

#### Recommended use is with the bash macros.

## Quick start

Install:

```bash
# set target
prefix=/prepend-path-here/limenv # <-- where this version will be installed
mkdir -p ${prefix}

tmp_build_dir=/path-to-temporary-build-directory
git clone https://github.com/1cosmologist/limenv ${tmp_build_dir}
cd ${tmp_build_dir}

unset PYTHONPATH
export LIMENVVERSION=$(date '+%Y%m%d')-0.0.0 # <-- name of this version
CONF=perlmutter PKGS=default PREFIX=${prefix} ./install.sh |& tee install.log
```

Load the environment installed above:

```bash
module use ${prefix}/${LIMENVVERSION}/modulefiles
module load limenv
```

Bash convenience macros:

```bash
limprefix=$SCRATCH/limenv
installlimenv () {

    tag=0.0.1
    branch=master
    if [ ! -z $1 ] ; then    tag=$1; fi
    if [ ! -z $2 ] ; then branch=$2; fi

    export PYTHONPATH=
    cd
    export LIMENVVERSION=$branch-$tag
    rm -rf $limprefix/$LIMENVVERSION
    tmp_build_dir=$SCRATCH/limenv
    rm -rf ${tmp_build_dir}
    git clone -b $branch https://github.com/1cosmologist/limenv ${tmp_build_dir}
    cd ${tmp_build_dir}
    # echo $PATH
    echo `which python`
    CONF=perlmutter PKGS=default PREFIX=${limprefix} ./install.sh |& tee install-${LIMENVVERSION}.log
}

loadlimenv () {
    
    tag=0.0.1
    branch=master
    if [ ! -z $1 ] ; then    tag=$1; fi
    if [ ! -z $2 ] ; then branch=$2; fi

    export LIMENVVERSION=$branch-$tag

    module unload cudatoolkit # ignore the systemwide cudatoolkit to avoid version conflicts
    module load cudatoolkit/12.2
    module load cudnn/8.9.3_cuda12
    module load cray-mpich craype-accel-nvidia80
    module use ${limprefix}/${LIMENVVERSION}/modulefiles
    module load limenv
    source ${limprefix}/${LIMENVVERSION}/conda/bin/activate
}
```
