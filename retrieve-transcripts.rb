require 'httparty'
require 'pry'
require 'json'

seasons = ["One", "Two", "Three"]

ids = []

seasons.each do |season|
  episodes = HTTParty.get("http://arresteddevelopment.wikia.com/api/v1/Articles/List?category=Season_#{season}_Transcripts&limit=50").parsed_response
  episodes["items"].each do |article_hash|
    ids.push(article_hash["id"])
  end
end

def save_episode_to_file(id)
  episode = HTTParty.get("http://arresteddevelopment.wikia.com/api/v1/Articles/AsSimpleJson?id=#{id}")
  File.open("transcripts/#{episode["sections"][0]["title"]}.json", "w") do |file|
    file.write episode.to_json
  end
end

ids.each do |id|
  save_episode_to_file(id)
end
