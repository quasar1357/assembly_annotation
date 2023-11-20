#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=4
#SBATCH --mem=4G
#SBATCH --time=00:30:00

#SBATCH --job-name=analysis
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_4_analysis_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/7_4_analysis_%j.e

module add UHTS/Analysis/SeqKit/0.13.2

# Define output and input directories
course_dir=/data/users/rschwob/01_assembly_annotation_course

# Input gff
gff=${course_dir}/results/7_annot_prots/run_mpi.maker.output/Ler_3_maker.all.maker.noseq.gff.renamed.gff
# Input blast
blast_in=${course_dir}/results/7_annot_prots/blast/Ler_3_maker_blastp.out

# Output dirs
out_dir=${course_dir}/results/7_annot_prots/analysis
mkdir -p ${out_dir}
# Output counts file
counts=${out_dir}/counts.txt
# Output bed file
out_bed=${out_dir}/Ler_3.bed
# Gene IDs file
out_gene_IDs=${out_dir}/Ler_3_gene_IDs.txt
# Blast output sorted for ID and e-value
sorted_blast=${out_dir}/Ler_3.blastp_sorted.out
# Best blast output
best_blast=${out_dir}/Ler_3.blastp_best.out

# Create bed file and a list of gene_IDs for all the protein coding genes
cat ${gff} | awk '$3=="mRNA"' | cut -f 1,4,5,9 | sed 's/ID=//' | sed 's/;.\+//' > ${out_bed}
cut -f4 ${out_bed} > ${out_gene_IDs}

# Count number of protein coding genes
gene_count=$(cat ${out_bed} | wc -l)
echo "protein-coding genes in genome:" ${gene_count} >> ${counts}

# Get a list of only the best blast matches (number of entries = number of proteins found in uniprot)
cat ${blast_in} | sort -t $'\t' -k1,1 -k11,11g > ${sorted_blast}
cat ${sorted_blast} | sort -u -t $'\t' -k1,1 --merge > ${best_blast}

# Count number of blast hits
blast_count=$(cat ${best_blast} | wc -l)
echo "blast hits:" ${blast_count} >> ${counts}

# Write percent of proteins with blast hits
percent=$(echo "scale=2; ${blast_count} / ${gene_count} * 100" | bc)
echo "percent of proteins with blast hits:" ${percent} >> ${counts}