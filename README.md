

Roman Schwob (roman.schwob@students.unibe.ch)

NOTE: Feel free to use any information, scripts or images from this repository, but please do provide a link or mention my name.

---
# Bioinformatics: Genome and transcriptome assembly and annotation


This project is part of the courses "Genome assembly" (473637) and "Organization and annotation of Eukaryote genomes" (SBL.30004) of the University of Bern and Fribourg, taking place in Fall Semester 2023/2024.

In this readme you find an overview over the steps performed, the tools used as well as their input and output. For an overview and evaluation of the main results, please refer to the [discussion](./DISCUSSION.md).

The general idea of the project is to perform an entire assembly and annotation based on whole genome NGS data of *Arabidopsis thaliana*.

**Goals**:
1) learn the theory of algorithmic assembly principles
2) apply it to data sets of both model & non-model organisms
3) assess the quality along the complete process from data generation to the genome/transcriptome assembly itself
4) annotate the genome by mapping the transcriptome assembly data to genome assembly data


## Dataset

The dataset originates from:

Jiao W.-B., Schneeberger K.: Chromosome-level assemblies of multiple Arabidopsis genomes reveal hotspots of rearrangements with altered evolutionary dynamics. Nature Communications. 2020;11:1–10. Available from: http://dx.doi.org/10.1038/s41467-020-14779-y

**Specific dataset used**:

- Accession: Ler
- Dataset: 3
- (Group for presentation: 4)

This dataset is itself composed of three types of **raw data**:

1) Whole genome Illumina paired-end libraries; short reads with high precision (Illumina)
2) Whole genome PacBio libraries; long reads with lower precision (pacbio)
3) Whole transcriptome Illumina RNA-seq paired-end libraries; short reads (RNAseq)

## Data analysis steps

### 1) Read quality and statistics
    Goal:       Analyse quality and statistics of raw reads
    Software:   FastQC 0.11.9
                Jellyfish 2.3.0
                GenomeScope 1.0
    Scripts:    1_QC_1_run_fastqc.slurm
                1_QC_2_run_jellyfish.slurm
    Input:      Raw reads fastq files
    Output:     Results of FastQC
                GenomeScope Profile

### 2) Assembly
    Goal:       Assemble Pacbio long reads into contigs using flye and canu
                Assemble Illumina RNAseq reads into transcriptome using trinity
    Software:   flye 2.8.3
                canu 2.1.1
                trinity 2.5.1
    Scripts:    2_assembly_1_run_flye.slurm
                2_assembly_2_run_canu.slurm
                2_assembly_3_run_trinity.slurm
    Input:      Raw reads fastq files (pacbio)
    Output:     Fasta file (per assembly)

### 3) Polishing of Pacbio assemblies using Illumina reads
    Goal:       Improve draft assemblies by genome polishing using Illumina reads (short but precise)
                Evaluate quality of assemblies (before and after polishing)
    Software:   bowtie2 2.3.4.1 (align Illumina reads to assemblies)
                samtools 1.10 (convert SAM to BAM, sort and index)
                pilon 1.22 (polish assemblies using Illumina short reads)
                busco 4.1.4 (evaluate and compare completeness of assemblies, based on universal orthologs)
                quast 4.6.0 (evaluate and compare many statistics including the contiguity)
                canu 2.1.1 (create meryl db)
                merqury 1.3.1 (evaluate quality of assemblies based on comparison of k-mers of unassembled Illumina short reads)
    Scripts:    3_polishing_1_align_illumina_1_create_bowtie_index.slurm
                3_polishing_1_align_illumina_2_align.slurm
                3_polishing_1_align_illumina_3_SAM_to_BAM.slurm
                3_polishing_2_run_pilon.slurm
                3_polishing_3_quality_ass_1_run_busco.slurm
                3_polishing_3_quality_ass_2_run_quast.slurm
                3_polishing_3_quality_ass_3a_run_meryl.slurm
                3_polishing_3_quality_ass_3b_run_merqury.slurm
    Input:      Assemblies (fasta files)
                Illumina short read raw data (fastq files)
                Reference genome (for quast)
    Output:     Alignment of Illumina reads onto Pacbio assemblies (BAM files, sorted and indexed)
                Polished assemblies
                Evaluation of quality of assemblies (busco and quast statistics, merqury kmer spectra)

### 4) Comparing Genomes
    Goal:       Compare genomes to reference (evaluate synteny)
                Compare genomes to each other
    Software:   mummer 4.0.0.beta1
    Scripts:    4_compare_genomes_1_run_nucmer.slurm
                4_compare_genomes_2_run_mummerplot.slurm
    Input:      Assemblies (fasta files)
                Reference genome
    Output:     mummerplots/dotplots (regions on assemblies/ref. plotted against each other)

### 5) Annotation of Transposable Elements (TEs)
    Goal:       EDTA: Produce a filtered non-redundant TE library for annotation of structurally intact and fragmented elements
                TEsorter: Make clade-level classification of Class I TEs (or retrotransposons, RTs)
    Software:   EDTA_v1.9.6
                TEsorter_1.3.0
    Scripts:    5_annotate_TEs_1_run_EDTA.slurm
                5_annotate_TEs_1_TE_comparison.ipynb
                5_annotate_TEs_2_sort_TEs_1_grep_copia_gypsy.slurm
                5_annotate_TEs_2_sort_TEs_2_run_TEsorter.slurm
                5_annotate_TEs_2_sort_TEs_3_run_TEsorter_on_db.slurm
                5_annotate_TEs_3_TEs_by_Clades_and_Range.r
    Input:      fasta of best polished assembly (i.e. flye --> pilon)
    Output:     EDTA:
                  Summary of whole-genome TE annotation (.mod.EDTA.TEanno.sum)                  
                  Repeat Masker comparison to ref (.mod.out, in sub-folder .mod.EDTA.TEanno)
                  gff with whole-genome TE annotation (.mod.EDTA.TEanno.gff3)
                  gff with annotation of intact only (.mod.EDTA.intact.gff3)                  
                  fasta with non-redundant TE library, classification into superfamilies (.mod.EDTA.TElib.fa)
                Python notebook:
                  Comparison of TE superfamiliy abundance between accessions
                TEsorter:
                  Annotated protein sequences, used for dating and phylogenetic analysis (.dom.faa)
                  TE classification (.cls.tsv)
                R-script:
                  Plot with arrangement of TEs of different families on the largest contig
    
### 6) TE dynamics (dating and phylogenetics)
    Goal:       Date TEs of different families
                Assess phylogeny inside 2 most important TE superfamilies (copia and gypsy)
    Software:   Date:
                  perl (6_dynamics_of_TEs_1_date_TEs_ParseML.pl, parse script, Aurelie Kapusta)
                Phylo:
                  clustal omega 1.2.4 (alignment)
                  FastTree 2.1.10 (tree creation)
                  iTOL (visualization; itol.embl.de)
    Scripts:    6_dynamics_of_TEs_1_date_TEs_1_run_ParseML.slurm
                6_dynamics_of_TEs_1_date_TEs_2_plot_dates.R
                6_dynamics_of_TEs_2_phylogenetics.slurm
    Input:      Date: Repeat Masker outputs from EDTA (.mod.out)
                Phylo: annotated protein sequences (.dom.faa) and classificication (.cls.tsv) from TEsorter
    Output:     Tables and plot of TEs with dates
                Phylogenetic trees of copia and gypsy superfamilies

### 7) Annotation of protein-coding sequences
    Goal:       Homology-based genome annotation (protein-coding genes)
                Quality assessment and evaluation of annotation
    Software:   MAKER pipeline 2.31.9
                busco 4.1.4 (assessment of quality/completeness)
                blast 2.10.1 (assessment of homology to known proteins in UniProt)
    Scripts:    7_annot_prots_1_maker_opts.ctl (maker config file)
                7_annot_prots_1_run_maker.slurm
                7_annot_prots_2_create_gff_fasta.slurm (merge results into 1 gff and fasta file each)
                7_annot_prots_3_rename_genes.slurm (build shorter IDs)
                7_annot_prots_4_assess_quality_1_run_busco.slurm
                7_annot_prots_4_assess_quality_2_blast.slurm
                7_annot_prots_4_assess_quality_3_analysis.slurm (evaluate annotation and blast numbers)
                7_annot_prots_4_assess_quality_4_compare_busco_changes.ipynb
    Input:      Genome assembly fasta file (pilon_bt2_flye.fasta)
                RNAseq assembly fasta file (Trinity.fasta)
                Repeat (TE) library in fasta format (.mod.EDTA.TElib.fa)
    References: fasta file with known protein sequences
                fasta file of transposable element proteins
    Output:     gff file of all annotated proteins (renamed with shorter IDs)
                fasta file of all annotated proteins (renamed with shorter IDs)
                fasta file of all annotated transcripts (renamed with shorter IDs)
                Evaluation of quality of annotation (busco and blast statistics)
                Comparison of quality of annotation (busco) to that of other groups

### 8) Comparative Genomics
    Goal:       Compare annotation of Ler accession with others (notably orthogroups and synteny; 10 longest contigs)
    Software:   genespace_1.1.4
                (SeqKit 0.13.2)
    Scripts:    8_comparative_genomics_1_create_bed.slurm
                8_comparative_genomics_2_run_genespace.slurm
                8_comparative_genomics_3_Parse_Orthofinder.R
    Input:      gff file of annotated proteins, renamed and merged, for each accession and the reference genome
                (OR bed file containing protein-coding genes of the longest contigs, made from annotation gff)
                fasta file of annotated proteins, renamed and merged, for each accession and the reference genome
                (OR fasta file containing peptide sequence of the longest contigs, made from annotation fasta)
    Output:     Table and plots with statistics about orthogroup sizes and proportion of genes assigned (Statistics_PerSpecies.tsv)
                Table and plot of co-occurrence of Orthogroups (Orthogroups.GeneCount.tsv)
                Dotplots of pairwise synteny
                Synteny map (riparian) with overview of contig arrangements accross accessions and reference genome

## Software used

Overview over all kinds of bioinformatics software, including most of the above:
https://bioinformaticshome.com/ \
Overview over software available on the ibu cluster:
https://www.vital-it.ch/
