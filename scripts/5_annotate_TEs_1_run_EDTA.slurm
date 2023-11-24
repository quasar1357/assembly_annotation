#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=50
#SBATCH --mem=10G
#SBATCH --time=05:00:00

#SBATCH --job-name=edta
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/5_1_edta_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/5_1_edta_%j.e

# Define input (assembly) and output paths
course_dir=/data/users/rschwob/01_assembly_annotation_course
    input_dir=${course_dir}/results/3_polishing_2_pilon
        assembly=${input_dir}/pilon_bt2_flye.fasta
    output_dir=${course_dir}/results/5_annotate_TEs_1_EDTA
    mkdir ${output_dir}
    cd ${output_dir}

COURSEDIR=/data/courses/assembly-annotation-course
    cds_file=${COURSEDIR}/CDS_annotation/TAIR10_cds_20110103_representative_gene_model_updated

#  Run EDTA (singularity container)
singularity exec \
--bind ${COURSEDIR} \
--bind ${output_dir} \
--bind ${input_dir} \
${COURSEDIR}/containers2/EDTA_v1.9.6.sif \
EDTA.pl \
--genome ${assembly} \
--species others \
--step all \
--cds ${cds_file} \
--anno 1 \
--threads 50

# INPUTS:
    # --genome: The genome FASTA
    # --cds: The coding sequences FASTA
    # --anno: Perform whole-genome TE annotation after TE library construction
    # --threads: Number of threads to run this script (default: 4)