require_relative '../lib/spotify_player'
require 'httparty'
require 'yaml'
require 'rufus-scheduler'

class Robut::Plugin::HipSpot

	include Robut::Plugin
	include PlaySpotify

	URL = YAML.load_file('config.yml')["server_url"]

	desc "!play <query> plays the desired Spotify tune"

  	match /^!play (.*)/ do |query|
  		# message = HTTParty.post(URL, body: {song: query}.to_json, headers: { 'Content-Type' => 'application/json' })
  		# reply JSON.parse(message)["message"]
  		store['track'] = query

  		player_state = `osascript -e 'tell application "Spotify" to player state'`.chomp
  		if player_state != 'playing'
	  		# play track query
	  		# reply playing_message
	  		create_playlist
	  		add_to_playlist query
	  		play @playlist["uri"]
	  		store['current_playlist'] = @playlist
  		else
  			create_playlist unless store['current_playlist']
  			store['current_playlist'] ? (@playlist = store['current_playlist']) : create_playlist
  			add_to_playlist query
  		end

  	end

  	match /!pause/ do
  		pause
  	end

  	match /!resume/ do
  		resume
  	end

end