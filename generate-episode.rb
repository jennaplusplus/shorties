require './client'
require 'json'
require 'uri'
require 'weighted_randomizer'

COLLECTION = '.my/ArrestedDevelopmentTrigrams'
N_PARTS = 300  # one run with 100 parts gave 2144 words, so triple that

client = Algorithmia.new

trigram_sizes = {}
client.trigram_files(COLLECTION).each do |file|
    character = file['filename']
    size = file['size']
    trigram_sizes[character] = size
end

randomizer = WeightedRandomizer.new(trigram_sizes)
parts = randomizer.sample(N_PARTS)

# episode starts with narration
parts.insert(0, 'Narrator.txt')

# no character speaks twice in a row
parts.each_with_index do |part, i|
    if i < parts.length - 1
        while parts[i] == parts[i+1]
            parts[i+1] = randomizer.sample
        end
    end
end

File.open('episode.txt', 'w') do |f|
    parts.each_with_index do |character_file, i|
        character = character_file.split('.txt')[0]
        $stderr.puts("Doing part #{i+1}/#{N_PARTS}, #{character}...")
        input = [
            "data://#{COLLECTION}/#{URI.encode(character_file)}", 
            "xxBeGiN142xx", "xxEnD142xx",
            rand(1..5),
        ]
        response = client.class.post(
            '/algo/lizmrush/GenerateParagraphFromTrigram/0.1.2',
            :body => input.to_json,
        )
        lines = JSON.parse(response.body)["result"]
        if lines.nil?
            puts response
            next
        end
        f.write(
            character + ": " + lines + "\n\n"
        )
        f.flush()
    end
end
