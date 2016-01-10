require 'dotenv'
require 'httparty'
Dotenv.load

class Algorithmia
    include HTTParty
    base_uri 'https://api.algorithmia.com/v1'
    headers "Authorization" => "Simple #{ENV['API_KEY']}"
    headers "Content-Type" => "application/json"
end
