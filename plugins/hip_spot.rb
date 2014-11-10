require_relative '../lib/spotify_player'
require 'httparty'

class Robut::Plugin::HipSpot

	include Robut::Plugin
	include PlaySpotify

	desc "!play <query> plays the desired Spotify tune"

  match /!new/ do
    create_playlist and save_playlist
    reply "Creating new playlist"
  end

	match /^!play (.*)/ do |query|

		player_state = `osascript -e 'tell application "Spotify" to player state'`.chomp
		
    get_playlist_from_store

    return reply "No playlist found. Type !new to create a new playlist" unless @playlist

		if player_state != 'playing'
  		add_to_playlist query
  		play @playlist["uri"]
  		reply "Thanks, #{sender}. Playing #{message}"
		else
			add_to_playlist query
			reply "Thanks, #{sender}. Queuing #{message}"
		end

	end

	match /!pause/ do
		pause
	end

	match /!resume/ do
    raise connection.roster.items.inspect
		resume
	end

end