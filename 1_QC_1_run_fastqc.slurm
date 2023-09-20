#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4000M
#SBATCH --time=01:00:00

#SBATCH --job-name=fastqc
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_fastqc_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_fastqc_%j.e

# Add the modules
module add UHTS/Quality_control/fastqc/0.11.9

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
fastq_parent_dir=${course_dir}/raw_data
output_parent_dir=${course_dir}/results/1_QC_1_FastQC
mkdir ${output_parent_dir}

# For each sequencing method, get input folder, create output folder and run the analysis
for fastq_dir in ${fastq_parent_dir}/*
do
    seq_method=$(basename "$fastq_dir")
    output_dir=${output_parent_dir}/${seq_method}
    mkdir ${output_dir}

    # Make the quality analysis
    fastqc -t 2 -o ${output_dir} ${fastq_dir}/*
        # Options:
            # "-t 2": Specifies the number of files which can be processed simultaneously.
            # "-o ${output_dir}": Create all output files in the specified output directory.
            # "${fastq_dir}/*.fastq.gz": Input all fastq files in the input directory.
done
