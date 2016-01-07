require './create-hash'
require 'json'
require 'pry'
require 'set'
require 'weighted_randomizer'

dialogue = get_dialogue
frequency = {}

dialogue.each do |key, value|
  frequency[key] = value.length
end

randomizer = WeightedRandomizer.new(frequency)

parts = randomizer.sample(300)

parts.each_with_index do |part, i|
  if i < parts.length - 1
    while parts[i] == parts[i+1]
      parts[i+1] = randomizer.sample
    end
  end
end

print parts
