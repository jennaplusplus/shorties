require 'dotenv'
require 'httparty'
require 'json'
Dotenv.load

class Algorithmia
    include HTTParty
    base_uri 'https://api.algorithmia.com/v1'
    headers "Authorization" => "Simple #{ENV['API_KEY']}"
    headers "Content-Type" => "application/json"

    def trigram_files(collection)
      response = self.class.get("/data/#{collection}")
      return JSON.parse(response.body)["files"]
    end
end
