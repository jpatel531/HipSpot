class Playlist

	extend Client
	include Client

	class << self

		def from_id(id)
			playlist_data = data_from_id(id)
			new playlist_data
		end

		def data_from_id(id)
			client.user_playlist SPOTIFY_USER, id
		end

		def from_store(store)
			from_id store['current_playlist']
		end

		def create(store)
			playlist = new
			playlist.save(store)
		end

	end

	attr_reader :id, :uri
	attr_accessor :data

	def initialize(data=nil)
		@data = (data) ? data : publish
		@id, @uri = @data['id'], @data['uri']
	end

	def publish
		data = client.create_user_playlist SPOTIFY_USER, SecureRandom.hex, true
	end

	def save(store)
		store['current_playlist'] = id
	end

	def refresh
		@data = self.class.data_from_id(id)
	end

	def last_song
		refresh
		data["tracks"]["items"].last["track"]["uri"]
	end

	def remove_song(index)
		refresh
		to_remove = data["tracks"]["items"][0 - index]["track"]["uri"]
		client.remove_user_tracks_from_playlist SPOTIFY_USER, id, [{uri: to_remove}]
	end

	def add(track)
		client.add_user_tracks_to_playlist SPOTIFY_USER, id, [track.id]
	end

	def is_last_song?(track)
		track.id == last_song
	end

end