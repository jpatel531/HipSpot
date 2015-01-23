require_relative '../lib/spotify_player'
require 'httparty'
require 'active_support/core_ext'

class Robut::Plugin::HipSpot

	include Robut::Plugin
	include PlaySpotify

	desc "!new creates a new playlist"
	match /!new/ do
		create_playlist and save_playlist
		reply "Creating new playlist"
		store['beyond_last_song'] = false
	end

	desc "!play <query> plays the desired Spotify tune. If a tune is already playing, it will queue in the playlist. Make sure you have started a !new playlist."
	match /^!play (.*)/ do |query|
		player_state = `osascript -e 'tell application "Spotify" to player state'`.chomp

		get_playlist_from_store

		return reply "No playlist found. Type !new to create a new playlist" unless @playlist

		if player_state != 'playing'
			add_to_playlist query
			if store['beyond_last_song'] === 'true'
				until is_current_song? query
					skip
				end
				resume
			else
				play @playlist["uri"]
			end
			reply "Thanks. Playing #{message}"
		else
			add_to_playlist query
			reply "Thanks. Queuing #{message}"
		end

		if is_last_song?(query)
			store['beyond_last_song'] = 'true'
		else
			store['beyond_last_song'] = 'false'
		end

	end

	desc "!pause(s) the current tune"
	match /!pause/ do
		pause
	end

	desc "!resume(s) the song"
	match /!resume/ do
		resume
	end

	desc "!remove(s) an unwanted song"
	match /^!remove(.*)/ do |index|
		get_playlist_from_store unless @playlist
		if index.blank?
			unwanted = 1
		else
			unwanted = index.match(/^\^(.*)/)[1].to_i
		end
		remove_song(unwanted)
		reply "Removed the #{unwanted.ordinalize} to last song in the queue." 
	end

end
