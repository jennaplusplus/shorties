require 'httparty'
require 'json'
require './create-hash'
require 'dotenv'
require 'pry'
Dotenv.load


# dialogue = get_dialogue

dialogue = {"Jenna" => ["Now that we have the sentences. we’ll pass those into the Generate Trigram Frequencies algorithm along with two tags that mark the beginning and ends of the data.", "Find this key in your Algorithmia profile by clicking on your user name in the top right-hand side of the Algorithmia site."]}

# the key is a character name
# the value is an array of all their lines of dialogue
dialogue.each do |character, paragraphs|
  # generate array of sentences
  trigram_file_name = "#{character}.txt"
  corpus = []
  paragraphs.each do |paragraph|
    response = HTTParty.post("https://api.algorithmia.com/v1/algo/StanfordNLP/SentenceSplit/0.1.0",
      :body => paragraph.to_json,
      :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Simple #{ENV['API_KEY']}" })
    corpus.push(JSON.parse(response.body)["result"])
  end
  corpus.flatten!

  # generate trigrams
  input = [corpus, "xxBeGiN142xx", "xxEnD142xx", "data://.algo/temp/" + "#{trigram_file_name}"]
  response = HTTParty.post("https://api.algorithmia.com/v1/algo/ngram/GenerateTrigramFrequencies/0.1.1",
      :body => input.to_json,
      :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Simple #{ENV['API_KEY']}" })
  puts response
end
