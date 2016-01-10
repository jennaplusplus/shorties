require './algoapi'
require 'json'
require './create-hash'
require 'dotenv'
require 'pry'
require 'uri'
Dotenv.load

MIN_SENTENCES = 10

dialogue = get_dialogue

trigram_collection = ".my/ArrestedDevelopmentTrigrams"

client = Algorithmia.new

# gather existing trigram files in collection
existing_files = []
response = client.class.get("/data/#{trigram_collection}")
JSON.parse(response.body)["files"].each do |file|
  existing_files.push(file["filename"])
end
puts existing_files

# the key is a character name
# the value is an array of all their lines of dialogue
dialogue.each do |character, paragraphs|
  trigram_file_name = "#{character.sub('/', '_')}.txt"

  if existing_files.include? trigram_file_name 
    puts "Already have trigrams for #{character}"
    next
  else
    if paragraphs.length < MIN_SENTENCES
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
    "data://#{trigram_collection}/#{URI.encode(trigram_file_name)}",
  ]
  response = client.class.post(
    "/algo/ngram/GenerateTrigramFrequencies/0.1.1",
    :body => input.to_json,
  )
end
