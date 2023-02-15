#!/usr/bin/env bash

set -e

# Catch different termination signals and kill all children processes.
trap "exit" INT TERM ERR
trap "kill 0" EXIT

method[0]="covariance"
method[1]="splitting"
method[2]="logistic"
method[3]="naive"
method[4]="q-learning"
method[5]="m-learning"

num_exp=10;

# Check whether gawk is installed.
if [ -z "$(command -v gawk)" ] ; then
    echo "Please install gawk."
    exit
fi
   
# Experiment setup.
exp=1
meth=4

# Compile extract-state function
if [ ! -e "extract-state" ] ; then
    g++ extract-state.cpp -o extract-state
fi

# Compile extract-control-action function
if [ ! -e "extract-control-action" ] ; then
    g++ extract-control-action.cpp -o extract-control-action
fi

while [ $exp -le $num_exp ]
do
    # Make the folder to place the results in. Overwrite previous results.
    dir="results-${method[meth]}/online-$exp"
    rm -r -f $dir; mkdir -p $dir
    pushd $dir > /dev/null

    # Construct the verifyta command to run.
    baseModel=../../pond_ADHS_online.xml
    #ln -s ../../extract-state
    echo "verifyta-stratego-8-7 -qs -D 0.5 --filter 2 --learning-method $meth --good-runs 10 --total-runs 20 --runs-pr-state 5 --eval-runs 5" > command.txt

    # The execution of the bash file depends on the bash executer one has.
    if [ -n "$(command -v sbatch)" ] ; then
	sbatch ../../online-experiment.sh
    else
	# The & ensures that we start all experiments in parallel and not one by one.
	../../online-experiment.sh &
	pids[${exp}]=$!
    fi
    popd > /dev/null

    exp=$((exp+1))
done

# Wait for all the processes to finish.
echo "Started $((exp-1)) experiments. Waiting for them to finish."
#for pid in ${pids[*]}; do
#    wait $pid
#done
wait
