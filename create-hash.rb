require 'json'
require 'pry'
require 'set'

def get_dialogue
  characters = Set.new
  dialogue = Hash.new

  Dir.glob('transcripts/*.json') do |json_file|
    json = File.read(json_file)
    data = JSON.parse(json)

    data["sections"].each do |section|
      section["content"].each do |content|
        if matches = content["text"].match(/^([^:]+): (.*)$/)
          character = matches[1]
          lines = matches[2]
          characters.add(character)
          dialogue[character] = [] if dialogue[character].nil?
          dialogue[character].push(lines)
        end
      end
    end
  end
  return dialogue
end

# 300 lines per episode
