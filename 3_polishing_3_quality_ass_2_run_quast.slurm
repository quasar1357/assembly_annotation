#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00

#SBATCH --job-name=quast
#SBATCH --output=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/output_quast_%j.o
#SBATCH --error=/data/users/rschwob/01_assembly_annotation_course/slurm_out_files/error_quast_%j.e

# Load quast
module add UHTS/Quality_control/quast/4.6.0

# Define input and output directories
course_dir=/data/users/rschwob/01_assembly_annotation_course
output_dir=${course_dir}/results/3_polishing_3_quality_assessment_2_quast
mkdir ${output_dir}
cd ${output_dir}

# Link and define reference genome
ref_genome=${course_dir}/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
ref_features=${course_dir}/references/TAIR10_GFF3_genes.gff

# Define input file and options

# WITH POLISHED ASSEMBLIES
assembly=${course_dir}/results/3_polishing_2_pilon/pilon_bt2_flye.fasta
output_tag=flye_polished

# assembly=${course_dir}/results/3_polishing_2_pilon/pilon_bt2_canu.fasta
# output_tag=canu_polished

# WITH ORIGINAL ASSEMBLIES (OPTIONAL)
# assembly=${course_dir}/results/2_assembly_1_flye/pacbio/assembly.fasta
# output_tag=flye_original

# assembly=${course_dir}/results/2_assembly_2_canu/pacbio/canu.contigs.fasta
# output_tag=canu_original

# Run quast
# Options:
    # -R <path>: Reference genome file. If this is omitted, QUAST will only report the metrics that can be evaluated without a reference.
    # --est-ref-size <int>: Estimated reference genome size (in bp) for computing NGx statistics. Used only if no reference genome file is specified.
    # --eukaryote (-e): Affects gene finding, conserved orthologs finding and contig alignment; By default, QUAST assumes circular genome, this option indicates that the genome is not circular.
    # --large: Genome is large (typically > 100 Mbp).In particular, imposes --eukaryote --min-contig 3000 --min-alignment 500 --extensive-mis-size 7000 (can be overridden manually with the corresponding options).
    # --threads (-t) <int>: Maximum number of threads. Default = 25% of all available CPUs but >= 1. If QUAST fails to determine the number of CPUs, max. threads number is set to 4. 
    # --labels (-l) <label,label...>: Human-readable assembly names
    # --features (-g) <path>: File with genomic feature positions in the reference genome. Otherwise, all features from the file will be considered.  

# WITHOUT REFERENCE
python /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py \
--est-ref-size 130m \
-e -t 8 --large \
-l ${output_tag}_no_ref ${assembly}

# WITH REFERENCE
python /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py \
-R ${ref_genome} --features ${ref_features} \
-e -t 8 --large \
-l ${output_tag}_ref ${assembly}