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
  		player_state = `osascript -e 'tell application "Spotify" to player state'`.chomp
  		

  		if player_state != 'playing'
	  		create_playlist
	  		add_to_playlist query
	  		play @playlist["uri"]
	  		reply "Thanks, #{@sender_name}. Playing #{message}"
  		else
  			store['current_playlist'] ? (@playlist = get_playlist_from store['current_playlist']) : create_playlist
  			add_to_playlist query
  			reply "Thanks, #{@sender_name}. Queuing #{message}"
  		end

  		store['current_playlist'] = @playlist["id"]


  	end

  	match /!pause/ do
  		pause
  	end

  	match /!resume/ do
  		resume
  	end

end