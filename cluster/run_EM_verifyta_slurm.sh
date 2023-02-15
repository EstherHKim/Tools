#!/bin/bash 
#SBATCH --time=600:05:00
#SBATCH --partition=rome,naples
#SBATCH --exclude=rome04,naples0[8-9]
#SBATCH --mem=4000

YEAR='2018'
WEEK_BACK_DATE=$(date -d "$MONTH/$DAY/$YEAR-7 days")
WEEK_BACK_MONTH=$(date -d "$WEEK_BACK_DATE" '+%m')
WEEK_BACK_DAY=$(date -d "$WEEK_BACK_DATE" '+%d')

echo "calculating normalization factor"

export START_DATA="$WEEK_BACK_MONTH $WEEK_BACK_DAY $OFF $L $I 1"
export WEIGHT_VALUES="1.0 1.0 1.0"
export SET_RUNS="1 $IT"

export STRATEGY_DIR=$(pwd)/normalization_factor/$WEEK_BACK_MONTH$WEEK_BACK_DAY/$SLURM_JOB_ID
mkdir -p $STRATEGY_DIR
echo "Running with normalization directory $STRATEGY_DIR"
RES=$(./uppaal/bin/verifyta -s -D 0.1 ./models/EM.xml 2>&1 )
echo "$RES" > $STRATEGY_DIR/Result.txt
comfort=$(sed '1q;d' $STRATEGY_DIR/cost_and_discomfort_values.txt)
cost=$(sed '2q;d' $STRATEGY_DIR/cost_and_discomfort_values.txt)
echo "$comfort is comfort"
echo "$cost is cost"
Norm=$(bc <<< "scale=4; $comfort / $cost")
echo "$Norm is the normalization factor "

echo "using normalization factor in full setup"

export START_DATA="$MONTH $DAY $OFF $L $I $C"
echo "$START_DATA is start data"
export WEIGHT_VALUES="$A $G $Norm"
echo "$WEIGHT_VALUES is weight_values"
export SET_RUNS="$RUNS $IT"
echo "$SET_RUNS is set runs"

GH=$(git rev-parse --short HEAD)
START=$(eval "printf \"M%dD%dH%dP%dI%dC%d\" $START_DATA")
WEIGHT=$(eval "printf \"A%0.2fG%fN%0.2f\" $WEIGHT_VALUES")
OPTS=$(eval "printf \"R%dI%d\" $SET_RUNS")
export STRATEGY_DIR=$(pwd)/results/$GH/$START/$WEIGHT/$OPTS/$SLURM_JOB_ID
echo "Running with strategy directory $STRATEGY_DIR"
mkdir -p $STRATEGY_DIR
cp ./intial_th_ti_for_LM/* $STRATEGY_DIR
RAND=$(od -A n -t dL -N 4 /dev/urandom)
export LM_SEED=$(od -A n -t dL -N 4 /dev/urandom)
RES=$(./uppaal/bin/verifyta --seed $RAND -s -D 0.1 ./models/EM.xml 2>&1 )
echo "$RES" > $STRATEGY_DIR/Result.txt
echo "Done"
