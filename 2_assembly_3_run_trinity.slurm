#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=1-00:00:00

#SBATCH --job-name=trinity
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_trinity_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_trinity_%j.e

# Add the modules
module add UHTS/Assembler/trinityrnaseq/2.5.1

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
fastq_parent_dir=${course_dir}/raw_data
output_parent_dir=${course_dir}/results/2_assembly_3_trinity
mkdir ${output_parent_dir}

# For the RNAseq library, get input folder and create output
# NOTE: since the output folder needs to contain "trinity" and we use RNAseq data only, we just use the output_parent folder
seq_method=RNAseq
fastq_dir=${fastq_parent_dir}/${seq_method}
output_dir=${output_parent_dir}
mkdir ${output_dir}

# Run trinity
Trinity --seqType fq --left ${fastq_dir}/*_1.fastq.gz --right ${fastq_dir}/*_2.fastq.gz --SS_lib_type RF --output ${output_dir} \
        --CPU 6 --max_memory 20G