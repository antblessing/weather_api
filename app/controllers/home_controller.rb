require 'Weather'

class HomeController < ActionController::Base

	def index
	end

	def weather
		@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NB KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC)
    @states.sort!


    city = params[:city] ||= "Sacramento"
    state = params[:state] ||= "CA"

    if city != '' && state != ''
    	city.gsub!(' ','_')
    	@cached = Weather.was_cached?(state, city)
			@weather = Weather.get_weather(state, city)
		end
		if !@weather
			flash[:notice] = "Problem fetching weather."
		end
	end

end