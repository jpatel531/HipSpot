require_relative '../lib/spotify_player'
require 'httparty'
require 'yaml'
require 'rufus-scheduler'

class Robut::Plugin::HipSpot

	include Robut::Plugin
	include PlaySpotify

	URL = YAML.load_file('config.yml')["server_url"]

	desc "!play <query> plays the desired Spotify tune"

  match /!new/ do
    create_playlist and save_playlist
  end

	match /^!play (.*)/ do |query|
		player_state = `osascript -e 'tell application "Spotify" to player state'`.chomp
		
    @playlist = get_playlist_from store['current_playlist']

    return reply "No playlist found. Type !new to create a new playlist" unless @playlist

		if player_state != 'playing'
  		add_to_playlist query
  		play @playlist["uri"]
  		reply "Thanks, #{private_sender}. Playing #{message}"
		else
			add_to_playlist query
			reply "Thanks, #{private_sender}. Queuing #{message}"
		end

	end

	match /!pause/ do
		pause
	end

	match /!resume/ do
		resume
	end

end