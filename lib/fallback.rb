require 'selenium-webdriver'
require 'youtube_it'

class Fallback

	def self.play(query)
		client = YouTubeIt::Client.new

		video_url = client.videos_by(query: query).videos[0].player_url

		driver = Selenium::WebDriver.for :chrome

		driver.navigate.to video_url

		wait = Selenium::WebDriver::Wait.new(timeout: 1000000000000000)

		wait.until { driver.execute_script("return document.getElementsByTagName('video')[0].ended") == true }

		driver.quit

	end

end