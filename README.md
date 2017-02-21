![bioinformatics-scripts](http://mkweb.bcgsc.ca/images/masthead/circos-genome-biology-mirna.png)
# bioinformatics-scripts
Collection of helper scripts &amp; utilities for biological research/bioinformatics

# Welcome to the bioinformatics-scripts wiki!

## Tool List
* taxonomy_data.rb - Probe Taxonomy Data for a species by it's scientific name. 
* build_fasta.rb - Create a working FASTA format file for an organism (tested).


```
Usage: build_fasta.rb [options] 
    -q, --query QUERY                NCBI format search query 
    -d, --download                   Downloads genomes as seperate fasta files 
    -f, --format FORMAT              Download Format 
    -m, --max-records NUMBER         Maximum Records return from search 
```

```
Usage: taxonomy_data.rb [options]
    -q, --query QUERY                NCBI search query
    -k, --keys LIST                  'TaxId', 'ScientificName', 'OtherNames', 'ParentTaxId', 'Rank', 'Division', 'GeneticCode', 'MitoGeneticCode', 'Lineage', 'LineageEx', 'CreateDate', 'UpdateDate', 'PubDate'
```

***



### To Do List
* Add asciinema screencast of scripts in action.
* Add CLI Blast utility
* Add SNP tracing utility
* Add homology probing utility
