#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00

#SBATCH --job-name=awk_pacbio_len
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_awk_pacbio_len_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_awk_pacbio_len_%j.e

file=/data/users/rschwob/01_assembly_annotation_course/raw_data/pacbio/ERR3415825.fastq.gz
# file=/data/users/rschwob/01_assembly_annotation_course/raw_data/pacbio/ERR3415826.fastq.gz
zcat $file | awk 'BEGIN{n=0; s=0} /length/ {++n; s=s+substr($3, 8)} END{print n; print s}'