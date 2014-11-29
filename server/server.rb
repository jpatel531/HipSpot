require 'sinatra'
require 'sinatra/json'
require_relative '../lib/spotify_player'

include PlaySpotify

post '/song' do

	player_state = `osascript -e 'tell application "Spotify" to player state'`.chomp

	# if player_state != 'playing'
	@playlist = get_playlist_from_id '0xOHx4NYKcqB88povdrdnj'
  	# get_playlist_from_store

  	# return reply "No playlist found. Type !new to create a new playlist" unless @playlist

	if player_state != 'playing'
			add_to_playlist query
			play @playlist["uri"]
			reply "Thanks, #{sender}. Playing #{message}"
	else
		add_to_playlist query
		reply "Thanks, #{sender}. Queuing #{message}"
	end

	# input = JSON.parse(request.body.read)["song"]
	# play track input
	# {message: playing_message}.to_json
end