library(ggplot2)
library(GENESPACE)
gpar <- init_genespace(wd = "/data/users/rschwob/01_assembly_annotation_course/results/8_comparative_genomics", path2mcscanx = "/data/users/rschwob/01_assembly_annotation_course/MCScanX")
out <- run_genespace(gsParam = gpar, overwrite = T)


