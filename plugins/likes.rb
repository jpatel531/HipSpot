require_relative '../lib/base'
require 'httparty'
require 'active_support/core_ext'

class Robut::Plugin::Likes

	include Robut::Plugin

	def handle(time, sender_nick, message)
		if message =~ /^!like(.*)/
			index = $1
			playlist = Playlist.from_store(store)
			if index.blank?
				like = 1
			else
				like = index.match(/^\^(.*)/)[1].to_i
			end
			song_uri = playlist.data["tracks"]["items"][0 - like]["track"]["uri"]
			store[sender_nick] = (store[sender_nick]) ? (store[sender_nick] << song_uri) : [song_uri]
			track = Track.from_uri song_uri
			reply "#{sender_nick} liked #{track.message}"
		end

	end

end