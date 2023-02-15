#!/bin/bash
#SBATCH --mail-type=ALL  # Type of email notification: BEGIN,END,FAIL,ALL
#SBATCH --mail-user=hki@cs.aau.dk
#SBATCH --partition=rome  # Which partitions may your job be scheduled on
#SBATCH --mem=100G  # Memory limit that slurm allocates
#SBATCH --time=3:00:00:00  # (Optional) time limit in dd:hh:mm:ss format. Make sure to keep an eye on your jobs (using 'squeue -u $(whoami)') anyways.

# Memory limit for user program
let "m=1024*1024*100"  
ulimit -v $m

#VERIFYTA_DIRECTORY=uppaal-4.1.20-stratego-10-linux64/bin/verifyta
VERIFYTA_DIRECTORY=stratego10/bin/verifyta

#MODEL_PATH=CruiseControlWithEulerMethod/cruise_minmax_corrected_only_new_method.xml
MODEL_PATH=cJLAMP2023/JLAMP_ADHS_1000cost_30000runs.xml

#QUERY_PATH=CruiseControlWithEulerMethod/cruise_minmax_corrected_new_method.q
QUERY_PATH=cJLAMP2023/JLAMP_ADHS_1000cost_30000runs.q

#RESULT_PATH=cJLAMP2023/result_JLAMP_ADHS_{}cost.txt
RESULT_PATH=cJLAMP2023/JLAMP_ADHS_1000cost_30000runs_1.txt

CMD="${VERIFYTA_DIRECTORY} -s ${MODEL_PATH} ${QUERY_PATH} >> ${RESULT_PATH}"

echo "${CMD}"
eval "${CMD}"
