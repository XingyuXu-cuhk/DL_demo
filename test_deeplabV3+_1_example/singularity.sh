#!/bin/bash
#SBATCH -J S2_r2
#SBATCH -N 1 
#SBATCH --gres=gpu:GTX1080Ti:2
#SBATCH --mem-per-cpu=4G
#SBATCH -c 8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=xuxingyu@link.cuhk.edu.hk

# the task
./run_INsingularity_miniconda.sh
