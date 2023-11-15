#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=20:00:00

#SBATCH --job-name=bed
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/8_1_bed_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/8_1_bed_%j.e

module add UHTS/Analysis/SeqKit/0.13.2

# Define output and input directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
maker_dir=${course_dir}/results/7_annot_prots/run_mpi.maker.output

# Define the base name of the files (accession/dataset)
base=Ler_3_maker
# Input gff
gff=${maker_dir}/${base}.all.maker.noseq.gff.renamed.gff
# Input fasta
fasta=${maker_dir}/${base}.all.maker.proteins.fasta.renamed.fasta
# Output dir
out_dir=${course_dir}/results/8_comparative_genomics
mkdir ${out_dir}
# Intermediate output files
out_contigs=${out_dir}/${base}_longest_contigs.txt
out_gene_IDs=${out_dir}/${base}_gene_IDs.txt
# Output bed
bed_dir=${out_dir}/bed
mkdir ${bed_dir}
out_bed=${bed_dir}/${base}.all.maker.noseq.gff.renamed.bed
# Output peptide
peptide_dir=${out_dir}/peptide
mkdir ${peptide_dir}
out_peptide=${peptide_dir}/${base}.all.maker.noseq.gff.renamed.fa


# Filter the gff for the third field ($3) "type" == "contig"; sort them in reverse order (-r) based on the fifth field ($5) "width" numerically (-n)
# cat ${gff} | awk '$3=="contig"' | sort -t $'\t' -k5 -n -r | head -n 10 > ${out_contigs}
cat ${gff} | awk '$3=="contig"' | sort -t $'\t' -k5 -n -r | cut -f 1,4,5,9 | sed 's/ID=//' | sed 's/;.\+//' | head -n 10 > ${out_contigs}

# DETAILS:
# -t $'\t': Specifies the field separator as a tab character (\t).
# -k5: Sorts based on the fifth field ($5)
# -n: sorts numerically (not alphabetically).
# -r: Sorts the lines in reverse order.

#Create bed file
cat ${gff} | awk '$3=="mRNA"' | cut -f 1,4,5,9 | sed 's/ID=//' | sed 's/;.\+//' | grep -w -f <(cut -f1 ${out_contigs}) > ${out_bed}

#Get the gene IDs
cut -f4 ${out_bed} > ${out_gene_IDs}

#Create fasta file
cat ${fasta} | seqkit grep -r -f ${out_gene_IDs} | seqkit seq -i > ${out_peptide}
