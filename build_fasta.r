#!/usr/bin/env Rscript
library('metacoder')
library('rentrez')
library('argparser')
library('ape')
library('seqinr')





p <- arg_parser("Downloads FASTA format file (multi-gene) for search term provided")
p <- add_argument(p, "--output", help="Output file", default="/tmp/test.fasta")
p <- add_argument(p, "--download", help="Build File on local filesystem", flag=TRUE)
p <- add_argument(p, "--search", help="NCBI Query String & Classifiers", default="Homo Sapiens[organism]")
p <- add_argument(p, "--maxr", help="Maximum amount of records to fetch from NCBI", default=100)

if (length(args)==0) {
  print(p)
  stop("Do The Right Thing!", call.=FALSE)
}

argv <- parse_args(p) 

searchterm <- argv$search

searchres <- entrez_search(db="nuccore", term=searchterm, retmax=argv$maxr)
seqs <- entrez_fetch(db="nuccore", searchres$ids, rettype="fasta")


dnabinobj <- read.GenBank(searchres$ids)

dnaattr <- attributes(dnabinobj)
dnanames <- names(dnabinobj)
genbankids <- paste(dnaattr, dnanames)

#print(dnabinobj)
print(genbankids)

write.fasta(sequences = seqs, names = dnanames, nbchar = 10, file.out = "/tmp/wannado.fasta")
