# Genome assembly of *A. thaliana* - questions of interest
## 1 - Read quality and statistics
### QC
1) What are the read lengths of the different datasets?
2) What kind of coverage do you expect from the Pacbio and the Illumina WGS reads? (hint: lookup the expected genome size of Arabidopsis thaliana)
3) Do all datasets have information on base quality?

### GenomeScope
1) Is the estimated genome size expected?
2) Is the percentage of heterozygousity expected?
3) Bonus: Why are we using canonical k-mers? (use Google)

## 2 - Assembly
### Polishing
1) How much does the polishing improve your assemblies (run the assembly evaluations on the polished and non-polished assemblies)?

## 3 - Assembly polishing and evaluation
### BUSCO
1) How do your genome assemblies look according to your BUSCO results? Is one genome assembly better than the other?
2) How does your transcriptome assembly look? Are there many duplicated genes? Can you explain the differences with the whole genome assemblies?

### QUAST
1) How do your genome assemblies look according to your QUAST results? Is one genome assembly better than the other?
2) What additional information you get if you have a reference available?

### Merqury
1) What are the consensus quality QV and error rate values of your assemblies?
2) What is the estimated completeness of your assemblies?
3) How does your copy-number spectra look like? Do they confirm the expected coverage?
4) Does one assembly perfom better than the other?

## 4 - Comparing Genomes
### nucmer and mummer
1) What does the dotplot show and what do the different colors mean?
2) Do your genome assemblies look very different from the reference genome?
3) How different are the two genome assemblies compared to each other?
4) (If you assembled different accessions: Do you see any differences between the accessions?)
