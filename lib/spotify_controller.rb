require 'spotify-client'
require 'securerandom'
require 'httparty'
require 'yaml'
require 'erb'

class SpotifyController
	class << self

		def play query
			`osascript -e 'tell application "Spotify" to play track "#{query}"'`
		end

		def pause
			`osascript -e 'tell application "Spotify" to pause'`
		end

		def resume
			`osascript -e 'tell application "Spotify" to play'`
		end

		def skip
			`osascript -e 'tell application "Spotify" to next track'`
		end

		def is_current_song?(track)
			`osascript -e 'tell application "Spotify" to id of current track'`.chomp == track.id
		end

		def player_state
			`osascript -e 'tell application "Spotify" to player state'`.chomp
		end

	end
end