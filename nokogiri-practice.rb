require 'open-uri'
require 'nokogiri'
require 'pry'

doc = Nokogiri::HTML(open("http://arresteddevelopment.wikia.com/wiki/Category:Season_One_Transcripts"))

doc.css("a")
