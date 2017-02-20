#!/usr/bin/env ruby 
require 'bio'
require 'optparse'
require 'xml2json'

def get_tax_id(arg)
	val = Bio::NCBI::REST::ESearch.taxonomy(arg)
	if val.count > 1
	  puts "Multiple Tax ID's returned from query" 
	  exit 1
	end
	return val
end

def get_tax_data(arg)
	val = XML2JSON.parse_to_hash(Bio::NCBI::REST::EFetch.taxonomy(arg, "xml"))
end

def verify_tax_data(hash)
	if hash["TaxaSet"].key?("Taxon")
		return hash["TaxaSet"]["Taxon"]
		puts "verified data..."
	else
		puts "No TaxaSet.Taxon key, bailing!"
		exit 1
	end
end

def print_data_with_options(hash, opts)
  opts.each do |o|
  	if hash.key?(o)
		puts "#{o}: #{hash[o].inspect}"
  	else
  	  puts "Key #{o} isn't in XML structure"
    end
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: taxonomy_data.rb [options]"

  opts.on("-q", "--query QUERY", "NCBI search query") do |o|
    options[:query] = o
  end

  opts.on("-k", "--keys LIST", Array, "'TaxId', 'ScientificName', 'OtherNames', 'ParentTaxId', 'Rank', 'Division', 'GeneticCode', 'MitoGeneticCode', 'Lineage', 'LineageEx', 'CreateDate', 'UpdateDate', 'PubDate'") do |o|
  	options[:keys] = o 
  end
end.parse!


ids = get_tax_id(options[:query])
raw = get_tax_data(ids)
parsed = verify_tax_data(raw)
print_data_with_options(parsed,options[:keys])
