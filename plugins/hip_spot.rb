require_relative '../lib/spotify_player'
require 'httparty'
require 'yaml'

class Robut::Plugin::HipSpot

	include Robut::Plugin
	include PlaySpotify

	URL = YAML.load_file('config.yml')["server_url"]

	desc "!play <query> plays the desired Spotify tune"

  	match /^!play (.*)/ do |query|
  		message = HTTParty.post(URL, body: {song: query}.to_json, headers: { 'Content-Type' => 'application/json' })
  		reply JSON.parse(message)["message"]
  	end



end