require 'httparty'
require 'json'
require './create-hash'
require 'dotenv'
require 'pry'
Dotenv.load

trigrams_file = 'data://.algo/ngram/GenerateTrigramFrequencies/temp/Tobias.txt'

output_file = "./tobias_dialogue.txt"

dialogue = ""

30.times do
  input = [trigrams_file, "xxBeGiN142xx", "xxEnD142xx", rand(1..5)]
  response = HTTParty.post('https://api.algorithmia.com/v1/algo/lizmrush/GenerateParagraphFromTrigram/0.1.2',
    :body => input.to_json,
    :headers => { 'Content-Type' => 'application/json', 'Authorization' => "Simple #{ENV['API_KEY']}" })
  dialogue = dialogue + JSON.parse(response.body)["result"] + "\n\n"
end

puts dialogue
