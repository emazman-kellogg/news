require "sinatra"
require "sinatra/reloader"
require "httparty"
def view(template); erb template.to_sym; end

get "/" do
  ### Get the weather
  # Swampscott, MA... my hometown!
  lat = 42.4709
  long = 70.9176

  units = "imperial" # or metric, whatever you like
  key = "3641e06cde19cf6994502ec0e2d500ab" # replace this with your real OpenWeather API key

  # construct the URL to get the API data (https://openweathermap.org/api/one-call-api)
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=#{units}&appid=#{key}"

  # make the call
  @forecast = HTTParty.get(url).parsed_response.to_hash

   @current_temp = []
    no_of_current_temp = 1
    no_of_current_temp.times do
        @current_temp << @forecast["current"]["temp"]
    end

    @current_desc = []
    no_of_current_desc = 1
    no_of_current_desc.times do
        @current_desc << @forecast["current"]["weather"][0]["main"]
    end        

    @future_temp = []
    no_of_future_temp = 8
    no_of_future_temp.times do
        @future_temp << @forecast["daily"]["temp"]["max"]
    end

    @future_desc = []
    no_of_future_desc = 8
    no_of_future_desc.times do
        @future_desc << @forecast["daily"]["weather"][0]["main"]
    end           

  ### Get the news
  url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=8aa0283a2c4b465493b55d5b8ba516d1"
  @news = HTTParty.get(url).parsed_response.to_hash
  # news is now a Hash you can pretty print (pp) and parse for your output

   @source = @news["name"]
   @author = @news["author"]
   @title = @news["title"]
   @description = @news["description"]
   @url = @news["url"]
   @url_to_image = @news["urlToImage"]
   @published_at = @news["publishedAt"]
   @content = @news["content"]



  view 'news'
end
