require_relative '../lib/spotify_player'
require 'httparty'

class Robut::Plugin::HipSpot

	include Robut::Plugin
	include PlaySpotify

	# URL = "http://localhost:9393/song"

	URL = "http://spotibot.ngrok.com/song"

	desc "!play <query> plays the desired Spotify tune"

  	match /^!play (.*)/ do |query|
  		message = HTTParty.post(URL, body: {song: query}.to_json, headers: { 'Content-Type' => 'application/json' })
  		reply JSON.parse(message)["message"]
  	end



end