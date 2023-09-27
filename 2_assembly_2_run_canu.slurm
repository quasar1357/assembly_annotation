#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pcourseassembly

#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=01:00:00

#SBATCH --job-name=canu
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_canu_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_canu_%j.e

# Add the modules
module add UHTS/Assembler/canu/2.1.1

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
fastq_parent_dir=${course_dir}/raw_data
output_parent_dir=${course_dir}/results/2_assembly_2_canu
mkdir ${output_parent_dir}

# For each sequencing method, get input folder, create output folder and run the analysis
for fastq_dir in ${fastq_parent_dir}/*
do
    seq_method=$(basename "$fastq_dir")
    output_dir=${output_parent_dir}/${seq_method}
    mkdir ${output_dir}

    # Run jellyfish
    jellyfish count -C -m 19 -s 5000000000 -t 10 -o ${output_dir}/reads.jf <(zcat ${fastq_dir}/*)
    jellyfish histo -t 10 ${output_dir}/reads.jf > ${output_dir}/reads.histo
done