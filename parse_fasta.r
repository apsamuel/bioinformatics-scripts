#!/usr/bin/env Rscript
library(metacoder)
args = commandArgs(trailingOnly=TRUE)


if (length(args)==0) {
  stop("Please add filename as argument.n", call.=FALSE)
}
filename = args[1]

fasta_path <- file.path(filename)
seq <- ape::read.FASTA(fasta_path)
genbank_ex_data <- extract_taxonomy(seq,
                                    regex = "^(NR.*) (.*),(.*,.*)$",
                                    key = c(gi_no = "obs_id", name = "name", desc = "obs_info"),
                                    database = "ncbi")
taxon_data(genbank_ex_data)

#not working

