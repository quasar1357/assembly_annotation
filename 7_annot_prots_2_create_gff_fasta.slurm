#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=02:00:00

#SBATCH --job-name=gff_fasta
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_2_gff_fasta_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_2_gff_fasta__%j.e

# Load the module
module load SequenceAnalysis/GenePrediction/maker/2.31.9

# Define output and input directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
maker_dir=${course_dir}/results/7_annot_prots/run_mpi.maker.output
cd ${maker_dir}

export TMPDIR=$SCRATCH
index_log=run_mpi_master_datastore_index.log
output_tag=Ler_3_maker

# Extract all sequences and annotations of these genes into one output data file each
gff3_merge -d ${index_log} -o ${output_tag}.all.maker.gff
gff3_merge -d ${index_log} -n -o ${output_tag}.all.maker.noseq.gff
fasta_merge -d ${index_log} -o ${output_tag}