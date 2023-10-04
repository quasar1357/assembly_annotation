#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=05:00:00

#SBATCH --job-name=bt2_align_canu
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_bt2_align_canu_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_bt2_align_canu_%j.e

# Add the modules
module add UHTS/Aligner/bowtie2/2.3.4.1

# Define and create output directory
course_dir=/data/users/rschwob/01_assembly_annotation_course
illumina_dir=${course_dir}/raw_data/Illumina
assembly_dir=${course_dir}/results/3_polishing_1_align_illumina
cd ${assembly_dir}

# Define input assembly
# assembly_tag=bt2_flye
assembly_tag=bt2_canu

# Run alignment with paired-end illumina reads and sensitive-local mode
bowtie2 -x ${assembly_tag} -1 ${illumina_dir}/*_1* -2 ${illumina_dir}/*_2* -S ${assembly_tag}.sam --sensitive-local