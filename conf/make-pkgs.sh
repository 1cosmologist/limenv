cd $CONDADIR
mkdir aux
cd aux
git clone https://github.com/lesgourg/class_public.git class
cd class
make

cd $SCRATCH
git clone git@github.com:kokron/skyLine.git