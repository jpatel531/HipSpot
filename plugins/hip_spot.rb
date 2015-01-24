require_relative '../lib/base'
require 'httparty'
require 'active_support/core_ext'

class Robut::Plugin::HipSpot

	include Robut::Plugin

	desc "!new creates a new playlist"
	match /!new/ do
		Playlist.create(store)
		reply "Creating new playlist"
		store['beyond_last_song'] = false
	end

	desc "!play <query> plays the desired Spotify tune. If a tune is already playing, it will queue in the playlist. Make sure you have started a !new playlist."
	match /^!play (.*)/ do |query|
		player_state = SpotifyController.player_state

		return reply "No playlist found. Type !new to create a new playlist" unless store['current_playlist']

		playlist = Playlist.from_store(store)
		track = Track.from_name(query)

		if player_state != 'playing'
			playlist.add(track)
			if store['beyond_last_song'] === 'true'
				until SpotifyController.is_current_song?(track)
					SpotifyController.skip
				end
				SpotifyController.resume
			else
				SpotifyController.play(playlist.uri)
			end
			reply "Playing #{track.message}"
		else
			playlist.add(track)
			reply "Queuing #{track.message}"
		end

		if playlist.is_last_song?(track)
			store['beyond_last_song'] = 'true'
		else
			store['beyond_last_song'] = 'false'
		end

	end

	desc "!pause(s) the current tune"
	match /!pause/ do
		SpotifyController.pause
	end

	desc "!resume(s) the song"
	match /!resume/ do
		SpotifyController.resume
	end

	desc "!remove(s) an unwanted song"
	match /^!remove(.*)/ do |index|
		playlist = Playlist.from_store(store)
		if index.blank?
			unwanted = 1
		else
			unwanted = index.match(/^\^(.*)/)[1].to_i
		end
		playlist.remove_song(unwanted)
		reply "Removed the #{unwanted.ordinalize} to last song in the queue." 
	end

	match /^fucking turn it down!|turn it down/ do |index|
		`osascript -e "set volume output volume (output volume of (get volume settings) - 10) --100%"`
		reply "Turning it down..."
	end

	match /^crank this shit up!|turn it up/ do |index|
		`osascript -e "set volume output volume (output volume of (get volume settings) + 10) --100%"`
		reply "Let's get our phunk on!"
	end

	match /!volume?/ do
		volume = `osascript -e "output volume of (get volume settings)"`.chomp
		reply "The volume is at #{volume}%"
	end

end