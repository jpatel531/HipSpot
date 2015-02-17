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
		handle_play_request query
	end

	def handle_play_request(query, from_uri = false)
		player_state = SpotifyController.player_state

		playlist = Playlist.from_store(store)

		return reply "No playlist found. Type !new to create a new playlist" unless store['current_playlist']

		track = (from_uri) ? Track.from_uri(query) : Track.from_name(query)

		return reply "Pack your bags and leave the UK, son. For that's the only way I'll play you this shit." unless track.available_in_uk?

		if player_state != 'playing'
			playlist.add(track)
			if store['beyond_last_song'] === true # the playlist has already finished and you wanna continue it with this track
				until SpotifyController.is_current_song?(track) 
					SpotifyController.skip #it will start from the beginning, skip until the next track
				end
				SpotifyController.resume 
			else
				SpotifyController.play(playlist.uri) #otherwise, play
			end
			reply "Playing #{track.message}"
		else 
			playlist.add(track) #the playlist is playing and it will just add the track on
			reply "Queuing #{track.message}"
		end

		if playlist.is_last_song?(track)
			store['beyond_last_song'] = true
		else
			store['beyond_last_song'] = false
		end
	end

	match /^!yt(.*)/ do |query|
		reply "Looking through YouTube..."
		Fallback.play query
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
		SpotifyController.change_volume(-10)
		reply "Turning it down..."
	end

	match /^crank this shit up!|turn it up/ do |index|
		SpotifyController.change_volume(10)
		reply "Let's get our phunk on!"
	end

	match /!volume?/ do
		reply "The volume is at #{SpotifyController.volume}%"
	end

	match /^this one goes out to (.*)/ do |recipient|
		track = store[recipient].sample
		handle_play_request track, true
	end

end