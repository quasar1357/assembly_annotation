#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=20:00:00

#SBATCH --job-name=genespace
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/8_2_genespace_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/8_2_genespace_%j.e

course_dir=/data/users/rschwob/01_assembly_annotation_course
genespace_image=${course_dir}/scripts/genespace_1.1.4.sif
genespace_script=${course_dir}/scripts/genespace.R

apptainer exec \
--bind ${course_dir} \
${genespace_image} Rscript ${genespace_script}
