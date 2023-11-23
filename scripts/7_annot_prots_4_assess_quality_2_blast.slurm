#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=20:00:00

#SBATCH --job-name=blast
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_4_blast_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_4_blast_%j.e

# Load blast
module load Blast/ncbi-blast/2.10.1+

# Define output and input directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
maker_dir=${course_dir}/results/7_annot_prots/run_mpi.maker.output

# Input uniprot fasta
uniprot_fasta=/data/courses/assembly-annotation-course/CDS_annotation/uniprot-plant_reviewed.fasta
# Intermediate output uniprot data base
blast_dir=${course_dir}/results/7_annot_prots/blast
mkdir ${blast_dir}
uniprot_db=${blast_dir}/uniprot.db

# Assembly input
base=Ler_3_maker
assembly=${maker_dir}/${base}.all.maker.proteins.fasta.renamed.fasta

# Final blast output
blast_out=${blast_dir}/${base}_blastp.out


# Create the blast protein data base
makeblastdb -in ${uniprot_fasta} -out ${uniprot_db} -dbtype prot
# Blast assembly against uniprot database (created in the step before)
blastp -query ${assembly} -db ${uniprot_db} -num_threads 10 -outfmt 6 -evalue 1e-10 -out ${blast_out}