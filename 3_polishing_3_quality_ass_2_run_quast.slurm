#!/usr/bin/env bash

#SBATCH --mail-user=roman.schwob@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --partition=pall

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00

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

# Define input file(s) and label(s)

# WITH POLISHED ASSEMBLIES
assembly1=${course_dir}/results/3_polishing_2_pilon/pilon_bt2_flye.fasta
output_tag1=flye_polished

assembly2=${course_dir}/results/3_polishing_2_pilon/pilon_bt2_canu.fasta
output_tag2=canu_polished

# WITH ORIGINAL ASSEMBLIES (OPTIONAL)
# assembly3=${course_dir}/results/2_assembly_1_flye/pacbio/assembly.fasta
# output_tag3=flye_original

# assembly4=${course_dir}/results/2_assembly_2_canu/pacbio/canu.contigs.fasta
# output_tag4=canu_original

# Run quast
# Options:
    # -R <path>: Reference genome file. If this is omitted, QUAST will only report the metrics that can be evaluated without a reference.
    # --est-ref-size <int>: Estimated reference genome size (in bp) for computing NGx statistics. Used only if no reference genome file is specified.
    # [--large: New shortcut in quast 5. Genome is large (typically > 100 Mbp). Use optimal parameters for evaluation of large genomes. Affects speed and accuracy. Imposes the following options:]
        # --eukaryote (-e): Genome is eukaryotic. Affects gene finding, conserved orthologs finding and contig alignment; By default, QUAST assumes circular genome, this option indicates that the genome is not circular.
        # --min-contig (-m) 3000: Lower threshold for contig length
        # --min-alignment (-i) 500: Nucmer's parameter: the minimum alignment length
        # --extensive-mis-size (-x) 7000: Lower threshold for extensive misassembly size. All relocations with inconsistency less than extensive-mis-size are counted as local misassemblies.
    # --threads (-t) <int>: Maximum number of threads. Default = 25% of all available CPUs but >= 1. If QUAST fails to determine the number of CPUs, max. threads number is set to 4. 
    # --labels (-l) <label,label...>: Human-readable assembly names
    # [--features (-g) <path>: New in quast 5. File with genomic feature positions in the reference genome. Otherwise, all features from the file will be considered.]

# WITHOUT REFERENCE
python /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py \
--est-ref-size 130000000 \
-e -m 3000 -i 500 -x 7000 -t 8 \
-l ${output_tag1}_no_ref,${output_tag2}_no_ref ${assembly1} ${assembly2}

# WITH REFERENCE
python /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py \
-R ${ref_genome} \
-e -m 3000 -i 500 -x 7000 -t 8 \
-l ${output_tag1}_no_ref,${output_tag2}_no_ref ${assembly1} ${assembly2}
# --features ${ref_features} --> not supported in quast 4.6.0