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
			current_song == track.id
		end

		def current_song
			`osascript -e 'tell application "Spotify" to id of current track'`.chomp
		end

		def player_state
			`osascript -e 'tell application "Spotify" to player state'`.chomp
		end

		def change_volume(difference)
			positive_negative = (difference >= 0) ? '+' : '-'
			difference = difference.abs
			`osascript -e "set volume output volume (output volume of (get volume settings) #{positive_negative} #{difference}) --100%"`
		end

		def volume
				`osascript -e "output volume of (get volume settings)"`.chomp
		end

	end
end