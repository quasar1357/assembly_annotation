#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=02:00:00

#SBATCH --job-name=rename
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_3_rename_genes_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_3_rename_genes_%j.e

# Load the module
module load SequenceAnalysis/GenePrediction/maker/2.31.9

# Define output and input directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
maker_dir=${course_dir}/results/7_annot_prots/run_mpi.maker.output
cd ${maker_dir}

# Define the input files created in the last step (combined fasta and gff files)
base=Ler_3_maker
protein=${base}.all.maker.proteins.fasta
transcript=${base}.all.maker.transcripts.fasta
gff=${base}.all.maker.noseq.gff
# Define a prefix to use
prefix=${base}_

# Create copies to not overwrite the originals
cp $gff ${gff}.renamed.gff
cp $protein ${protein}.renamed.fasta
cp $transcript ${transcript}.renamed.fasta

# Run the renaming, i.e. build shorter IDs and map them to MAKER fasta and gff files
maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > ${base}.id.map
map_gff_ids ${base}.id.map ${gff}.renamed.gff
map_fasta_ids ${base}.id.map ${protein}.renamed.fasta
map_fasta_ids ${base}.id.map ${transcript}.renamed.fasta