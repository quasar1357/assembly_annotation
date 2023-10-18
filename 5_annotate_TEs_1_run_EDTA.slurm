#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=50
#SBATCH --mem=10G
#SBATCH --time=05:00:00

#SBATCH --job-name=edta
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_edta_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_edta_%j.e

# Define input (assembly), output paths
# input_dir=/data/users/ivilela/assembly_annotation_course/bowtie
# assembly=${input_dir}/pilonFlye.fasta
# output_dir=/data/users/rschwob/01_assembly_annotation_course/results/5_annotate_TEs
input_dir=/data/users/rschwob/01_assembly_annotation_course/results/3_polishing_2_pilon
assembly=${input_dir}/pilon_bt2_flye.fasta
output_dir=/data/users/rschwob/01_assembly_annotation_course/results/5_annotate_TEs_ROMAN
mkdir ${output_dir}
cd ${output_dir}

COURSEDIR=/data/courses/assembly-annotation-course
cds_file=${COURSEDIR}/CDS_annotation/TAIR10_cds_20110103_representative_gene_model_updated

singularity exec \
--bind ${COURSEDIR} \
--bind ${output_dir} \
--bind ${input_dir} \
${COURSEDIR}/containers2/EDTA_v1.9.6.sif \
EDTA.pl \
--genome ${assembly} \ # The genome FASTA
--species others \
--step all \
--cds ${cds_file} \ # The coding sequences FASTA
--anno 1 \ # perform whole-genome TE annotation after TE library construction
--threads 50 # Number of threads to run this script (default: 4)