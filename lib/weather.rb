require 'httparty'

class Weather 
	include HTTParty
	format :json

	base_uri 'http://api.wunderground.com'

	attr_accessor :temp, :location, :forecast

	def initialize(response,response_forecast)
		@temp = response['current_observation']['temp_f']
		@location = response['current_observation']['display_location']['full']
		@forecast = response_forecast['forecast']['txt_forecast']['forecastday']
	end

	def self.get_weather(state, city)
		api_url = base_uri + "/api/#{ENV["weather_key"]}/conditions/q/#{state}/#{city}.json"
		forecast_url = base_uri + "/api/#{ENV["weather_key"]}/forecast10day/q/#{state}/#{city}.json"

		default_url = base_uri + "/api/#{ENV["weather_key"]}/conditions/q/CA/Sacramento.json"
		default_forecast_url = base_uri + "/api/#{ENV["weather_key"]}/forecast10day/q/CA/Sacramento.json"

		response = get(api_url)
		response_forecast = get(forecast_url)

		if !response['current_observation']
			response = get(default_url)
			response_forecast = get(default_forecast_url)
		end

		cache_key = state + city

		Rails.cache.fetch(cache_key, expires_in: 30.seconds) do

			if response.success?
				new(response,response_forecast)
			else
				nil
			end
		end
	end

	def self.was_cached?(state,city)
		Rails.cache.exist?(state+city)
	end
end

# 'http://api.wunderground.com/api/231aeb0b239fb14a/conditions/q/CA/Concrd.json'