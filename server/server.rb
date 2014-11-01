require 'sinatra'
require 'sinatra/json'
require_relative '../hip_spot'

include PlaySpotify

post '/song' do
	input = JSON.parse(request.body.read)["song"]
	play track input
end