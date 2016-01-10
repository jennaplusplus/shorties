require './client'
require 'json'
require './create-hash'
require 'dotenv'
require 'pry'
require 'uri'
Dotenv.load

COLLECTION = ".my/ArrestedDevelopmentTrigrams"
MIN_LINES = 10

dialogue = get_dialogue

client = Algorithmia.new

# gather existing trigram files in collection
existing_files = []
client.trigram_files(COLLECTION).each do |file|
  existing_files.push(file["filename"])
end

# the key is a character name
# the value is an array of all their lines of dialogue
dialogue.each do |character, paragraphs|
  trigram_file_name = "#{character.sub('/', '_')}.txt"

  if existing_files.include? trigram_file_name 
    puts "Already have trigrams for #{character}"
    next
  else
    if paragraphs.length < MIN_LINES
      # skip characters with very few lines
      puts "Skipping #{character}: only #{paragraphs.length} lines"
      next
    else
      puts "Generating trigrams for #{character}..."
    end
  end

  # generate array of sentences
  response = client.class.post(
    "/algo/StanfordNLP/SentenceSplit/0.1.0",
    :body => paragraphs.join(" ").to_json,
  )
  corpus = (JSON.parse(response.body)["result"])

  # generate trigrams
  input = [
    corpus,
    "xxBeGiN142xx", "xxEnD142xx",
    "data://#{COLLECTION}/#{URI.encode(trigram_file_name)}",
  ]
  response = client.class.post(
    "/algo/ngram/GenerateTrigramFrequencies/0.1.1",
    :body => input.to_json,
  )
end
