#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=20:00:00

#SBATCH --job-name=busco
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_4_busco_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_4_busco_%j.e

# Load busco
module add UHTS/Analysis/busco/4.1.4

# Define output and input directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
maker_dir=${course_dir}/results/7_annot_prots/run_mpi.maker.output
cd ${maker_dir}

base=Ler_3_maker
assembly=${base}.all.maker.proteins.fasta.renamed.fasta
output_dir=${base}_busco

# Make Augustus config file writable (temporarily copy to working directory)
cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config augustus_config
export AUGUSTUS_CONFIG_PATH=./augustus_config

# Run busco in protein mode
busco  --lineage_dataset brassicales_odb10 --cpu 8 \
-i ${assembly} -o ${output_dir} --mode proteins

# Remove the copied temporary config files
rm -r ./augustus_config