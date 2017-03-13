#!/usr/bin/env ruby 
require 'bio'
require 'optparse'
require 'xml2json'

#ncbi = Bio::NCBI::REST.new
#ncbi.esearch("Hymenoptera[organism]", { "db"=>"gene", "rettype"=>"gb", "retmax"=> 10000000})
# Bio::NCBI::REST::EFetch.nucleotide(ncbi.esearch("Homo Sapiens[organism]", { "db"=>"gene", "rettype"=>"fasta", "retmax"=> 100}))


def get_gene_ids(opts)
	#ncbi = Bio::NCBI::REST.new
	#Bio::NCBI::REST::ESearch.search("nucleotide", "Homo Sapiens[organism]", 1000), "fasta")
	val = Bio::NCBI::REST::ESearch.search("nucleotide", opts[:query], opts[:max])
	#val = ncbi.esearch(opts[:query], { "db"=>"nucleotide", "rettype"=> opts[:format], "retmax"=> opts[:max] })
	if val.count == 0
	  puts "No GI's returned for your search, sorry - try again" 
	  exit 1
	end
	return val
end

def fetch_data_from_ids(ids,opts)
	ncbi = Bio::NCBI::REST.new 

	#TODO: add error checks
	if opts[:download] == true
	  puts "ID Count: #{ids.size}"
	  #handle array in chunks of 10
	  #stop count down at 1, which is some type of null record, or my code is wrong..
	  until (ids.size == 1) do
	  	slice = ids.slice!(1..10)
		puts "downloading id's #{slice} ..."
		#records = ncbi.efetch(slice, { "db"=>"gene", "rettype" => opts[:format] } )
		records = Bio::NCBI::REST::EFetch.nucleotide(slice, opts[:format])
	    records.gsub!("\n\n","\n")
	    filename = opts[:query].gsub(" ", "_").gsub("[","_").gsub("]","") + ".#{opts[:format]}"
	    #File.open(filename, 'a')  {|f| f.write(records + "\n") }
        File.open(filename, 'a')  {|f| f.write(records) }
	    #relax for a bit
	    Kernel.sleep 2
	  end
	else
	  #just print to STDOUT
	  until (ids.size == 1) do
	  	slice = ids.slice!(1..10)
		puts "downloading id's #{slice} ..."
		puts "#{ids.size} genes remaining...."
		Kernel.sleep 1
		#records = ncbi.efetch(slice, { "db"=>"gene", "rettype" => opts[:format] } )
		records = Bio::NCBI::REST::EFetch.nucleotide(slice, "xml")
	    # records.gsub!("\n\n","\n")
            recordshash = XML2JSON.parse_to_hash(records)
	    if recordshash['INSDSet'].key?('INSDSeqs')
              if recordshash['INSDSet']['INSDSeqs'].count > 0
	        recordshash['INSDSet']['INSDSeqs'].each do |rec|
	          puts "~" * 100
	          attrs = {
	            "definition": "INSDSeq_definition",
	            "organism": "INSDSeq_organism",
	            "taxonomy": "INSDSeq_taxonomy",
	            "locus": "INSDSeq_locus", 
	            "length": "INSDSeq_length", 
	            "strandeness": "INSDSeq_strandedness", 
		    "molecule_type": "INSDSeq_moltype",
		    "topology": "INSDSeq_topology",
		    "division": "INSDSeq_division",
		    "creation_date": "INSDSeq_create-date",
		    "update_date": "INSDSeq_update-date",	 
		    "primary_accession": "INSDSeq_primary-accession",
		    "secondary_accession": "INSDSeq_secondary-accessions"
                  }

		  #print attributes under each returned seq.
                  attrs.keys.each do |k|
		    if rec.key?(attrs[k])
                      puts "#{k}: #{rec[attrs[k]]}"
		    end
		  end
		end

	      else
		puts "Something went wrong with the record set.. add more debugging here..."
		exit 1
	      end
	    end
	    #puts records
	    #Kernel.sleep 2
	  end
	end

end



options = {}
options[:download] = false
options[:format] = "fasta"
options[:max] = 10000000 #10 million is a good default

OptionParser.new do |opts|
  opts.banner = "Usage: build_fasta.rb [options]"

  opts.on("-q", "--query QUERY", "NCBI format search query") do |o|
	  if  o !~ /\[.+\]/
		  puts "You should add an NCBI identifier to stabilize your query. Ex: 'Homo Sapiens[organism]'"
	    exit 1
	  else
            options[:query] = o
	  end

  end

  opts.on("-d", "--download", "Downloads genomes as seperate fasta files") do |o|
  	options[:download] = true 
  end

  opts.on("-f", "--format FORMAT", "Download Format") do |o|
  	options[:format] = o
  end

  opts.on("-m", "--max-records NUMBER", "Maximum Records return from search") do |o|
  	options[:max] = o
  end

end.parse!

#do the things
ids = get_gene_ids(options)
fetch_data_from_ids(ids,options)

