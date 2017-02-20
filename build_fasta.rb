#!/usr/bin/env ruby 
require 'bio'
require 'optparse'
require 'xml2json'

#ncbi = Bio::NCBI::REST.new
#ncbi.esearch("Hymenoptera[organism]", { "db"=>"gene", "rettype"=>"gb", "retmax"=> 10000000})
# Bio::NCBI::REST::EFetch.nucleotide(ncbi.esearch("Homo Sapiens[organism]", { "db"=>"gene", "rettype"=>"fasta", "retmax"=> 100}))


def get_gene_ids(opts)
	ncbi = Bio::NCBI::REST.new
	val = ncbi.esearch(opts[:query], { "db"=>"nucleotide", "rettype"=> opts[:format], "retmax"=> opts[:max] })
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
	    filename = opts[:query].gsub("\W", "")
	    File.open(filename, 'a')  {|f| f.write(records + "\n") }
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
		records = Bio::NCBI::REST::EFetch.nucleotide(slice, opts[:format])
	    records.gsub!("\n\n","\n")
	    puts records
	    Kernel.sleep 2
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
    options[:query] = o
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

