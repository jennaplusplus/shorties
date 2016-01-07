require 'httparty'
require 'json'
require './create-hash'
require 'dotenv'
require 'pry'
Dotenv.load


dialogue = get_dialogue

# the key is a character name
# the value is an array of all their lines of dialogue
dialogue.each do |character, paragraphs|
  if character == "Tobias"

    # generate array of sentences
    trigram_file_name = "#{character}.txt"
    response = HTTParty.post("https://api.algorithmia.com/v1/algo/StanfordNLP/SentenceSplit/0.1.0",
      :body => paragraphs.join(" ").to_json,
      :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Simple #{ENV['API_KEY']}" })
    corpus = (JSON.parse(response.body)["result"])

    # generate trigrams
    input = [corpus, "xxBeGiN142xx", "xxEnD142xx", "data://.algo/temp/" + "#{trigram_file_name}"]
    response = HTTParty.post("https://api.algorithmia.com/v1/algo/ngram/GenerateTrigramFrequencies/0.1.1",
        :body => input.to_json,
        :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Simple #{ENV['API_KEY']}" })
  end
end
