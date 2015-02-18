# end_checker = Thread.new do

# 	loop do 

# 		playlist = Playlist.from_store(store)
# 		@playing_last_song = (SpotifyController.current_song == playlist.last_song)

# 		playlist_completed = @playing_last_song && (SpotifyController.player_state == 'stopped') 

# 		sleep 1

# 	end


# end