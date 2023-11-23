

Roman Schwob (roman.schwob@students.unibe.ch)

---
# Bioinformatics: Genome and transcriptome assembly and annotation


This project is part of the courses "Genome assembly" (473637) and "Organization and annotation of Eukaryote genomes" (SBL.30004) of the University of Bern and Fribourg, taking place in Fall Semester 2023/2024.

This readme gives a rough overview over the steps performed. For a in-detail discussion of the results, please refer to the [discussion file](./DISCUSSION.md).

The general idea of the project is to perform an entire assembly and annotation based on whole genome NGS data of *Arabidopsis thaliana*.

**Goals**:
1) learn the theory of algorithmic assembly principles
2) apply it to data sets of both model & non-model organisms
3) assess the quality along the complete process from data generation to the genome/transcriptome assembly itself
4) annotate the genome by mapping the transcriptome assembly data to genome assembly data


## Dataset

The dataset originates from:

Jiao WB, Schneeberger K. Chromosome-level assemblies of multiple Arabidopsis genomes reveal hotspots of rearrangements with altered evolutionary dynamics. Nature Communications. 2020;11:1–10. Available from: http://dx.doi.org/10.1038/s41467-020-14779-y

**Specific dataset used**:

- Accession: Ler
- Dataset: 3
- (Group for presentation: 4)

This dataset is itself composed of three types of **raw data**:

1) Whole genome Illumina (Illumina)
2) Whole genome PacBio (pacbio)
3) Whole transcriptome Illumina RNA-seq (RNAseq)

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
    Input:      Raw reads fastq files
    Output:     Fasta file (per assembly)

### 3) Polishing of Pacbio assemblies using precise Illumina reads
    Goal:       Improve draft assemblies by genome polishing using Illumina reads
                Evaluate quality of assemblies (before and after polishing)
    Software:   bowtie 2.3.4.1 (align Illumina reads to assemblies)
                samtools 1.10 (convert SAM to BAM, sort and index)
                pilon 1.22 (polish assemblies using Illumina short reads)
                busco 4.1.4 (evaluate quality of assemblies)
                quast 4.6.0 (evaluate quality of assemblies)
                canu 2.1.1 (create meryl db)
                merqury 1.3.1 (evaluate quality of assemblies)
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
                Evaluation of quality of assemblies (busco, quast and merqury)

### 4) Comparing Genomes
    Goal:       Compare genomes to reference (evaluate synteny)
                Compare genomes to each other
    Software:   mummer 4.0.0beta1
    Scripts:    4_compare_genomes_1_run_nucmer.slurm
                4_compare_genomes_2_run_mummerplot.slurm
    Input:      Assemblies (fasta files)
                Reference genome
    Output:     mummerplots (regions on assemblies/ref. plotted against each other)

### 5) Annotation of Transposable Elements (TEs)
    Goal:       Produce a filtered non-redundant TE library for annotation of structurally intact and fragmented elements
    Software:   EDTA_v1.9.6
                TEsorter_1.3.0
    Scripts:    5_annotate_TEs_1_run_EDTA.slurm
                5_annotate_TEs_2_sort_TEs_1_grep_copia_gypsy.slurm
                5_annotate_TEs_2_sort_TEs_2_run_TEsorter.slurm
                5_annotate_TEs_2_sort_TEs_3_run_TEsorter_on_db.slurm
                5_annotate_TEs_3_TEs_by_Clades_and_Range.r
    Input:      fasta of best, polished assembly (i.e. flye --> pilon)
    Output:     EDTA:
                  fasta (.mod.EDTA.TElib.fa)
                  gff (.mod.EDTA.TEanno.gff3)
                  summary (.mod.EDTA.TEanno.sum)
                  gff of intact only (.mod.EDTA.intact.gff3)
                  comparison to ref (.mod.EDTA.anno/.mod.out)
                TEsorter:
                  annotated protein sequences, used for dating and phylogenetic analysis (.liban.rexdb-plant.dom.faa)
                  TE classification (.liban.rexdb-plant.cls.tsv)
                R-script:
                  arrangement of TEs of different families on the largest contig
    
### 6) TE dynamics (dating an phylogenetics)
    Goal:       Date TEs of different families
                Assess phylogeny inside 2 most important superfamilies (copia and gypsy)
    Software:   
    Scripts:    
    Input:      
    Output:     

### 7) Annotation of protein-coding sequences
    Goal:       
    Software:   
    Scripts:    
    Input:      
    Output:     

### 8) Comparative Genomics
    Goal:       
    Software:   
    Scripts:    
    Input:      
    Output:     

## Software used

Overview over all kinds of bioinformatics software, including most of the above:
https://bioinformaticshome.com/
Overview over software available on the ibu cluster:
https://www.vital-it.ch/
