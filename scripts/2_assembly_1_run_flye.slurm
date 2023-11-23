#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00

#SBATCH --job-name=flye
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_flye_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_flye_%j.e

# Add the modules
module add UHTS/Assembler/flye/2.8.3

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
fastq_parent_dir=${course_dir}/raw_data
output_parent_dir=${course_dir}/results/2_assembly_1_flye
mkdir ${output_parent_dir}

# For the pacbio library, get input folder and create output
seq_method=pacbio
fastq_dir=${fastq_parent_dir}/${seq_method}
output_dir=${output_parent_dir}/${seq_method}
mkdir ${output_dir}

# Run flye
flye --pacbio-raw ${fastq_dir}/* --out-dir ${output_dir} --threads 8