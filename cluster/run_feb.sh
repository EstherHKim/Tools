
#!/bin/bash

N=10
export L='7'
export I='1'
export IT='5'


#running Jan week
export MONTH='2'
export DAY='4'
export OFF='0'
E=1 #0 for Th,Te from EM; 1 for Th,Te from LM


export C=0
for R in 1 5 10 20 40 80 160 300; do
export  RUNS="$R" 

for i in $(seq 0 10 ) ; do
        export A=$(echo "$i/10" | bc -l)
        export G=$(echo "1-$A" | bc -l)
        export LOAD_ESTIMATED_TH_TE="$E"
        for i in $(seq 1 $N); do sbatch run_EM_verifyta_slurm.sh ; done


done
done
#exit
export C=1
for R in 1 ; do
export  RUNS="$R"
for i in $(seq 0 10 ) ; do
        export A=$(echo "$i/10" | bc -l)
        export G=$(echo "1-$A" | bc -l)
        export LOAD_ESTIMATED_TH_TE="$E"
        for i in $(seq 1 $N); do sbatch run_EM_verifyta_slurm.sh ; done

done
done

#!/bin/bash

N=10
export L='7'
export I='6'
export IT='5'


#running Jan week
export MONTH='2'
export DAY='4'
export OFF='0'
E=1 #0 for Th,Te from EM; 1 for Th,Te from LM


export C=0
for R in 1 5 10 20 40 80 160 300; do
export  RUNS="$R" 

for i in $(seq 0 10 ) ; do
        export A=$(echo "$i/10" | bc -l)
        export G=$(echo "1-$A" | bc -l)
        export LOAD_ESTIMATED_TH_TE="$E"
        for i in $(seq 1 $N); do sbatch run_EM_verifyta_slurm.sh ; done


done
done
#exit
export C=1
for R in 1 ; do
export  RUNS="$R"
for i in $(seq 0 10 ) ; do
        export A=$(echo "$i/10" | bc -l)
        export G=$(echo "1-$A" | bc -l)
        export LOAD_ESTIMATED_TH_TE="$E"
        for i in $(seq 1 $N); do sbatch run_EM_verifyta_slurm.sh ; done

done
done



