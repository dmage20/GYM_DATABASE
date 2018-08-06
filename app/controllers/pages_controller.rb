class PagesController < ApplicationController
  require 'unsplash'
  require 'open-uri'
  require 'nokogiri'
  require 'i18n'
  skip_before_action :authenticate_user!, only: [:home, :gyms]

  def home
    @gym = Gym.new

      @gyms = Gym.all.sample(9)


        @markers = @gyms.map do |gym|
        {
          lat: gym.latitude,
          lng: gym.longitude,
          infoWindow: { content: render_to_string(partial: "/gyms/map_box", locals: { gym: gym }) }
        }
      end

      # create items for the country profile
      # @coutries = Country.order('gyms_count').last(25).sample(6)
      # City.order('gyms_count').last(50).sample(9)
      @cities = City.order('gyms_count').last(50).sample(9)

      # call the workout_profile function and pass it crossfit mayhem
      workout_profile("thecrossfitmayhem")
      # add unsplash image to each city in @cities
      @unsplash_cities = @cities.each do |city|
      # search_results = Unsplash::Photo.search(city.name, page = 1, per_page = 10, orientation = "landscape").sample
      url = "https://api.unsplash.com/search/photos?client_id=7f4b6697803bdc15bc73567bde8958a895445fbf1b0af13352b8169bf99b84b3&query=#{city.name}&per_page=10"
      response = open(I18n.transliterate(url)).read
      @response_parsed = JSON.parse(response)
       # binding.pry
      city.url =  @response_parsed["results"].first(5).sample["urls"]["small"] if !@response_parsed["results"].blank?
      end

  end

    # helper_method :unsplash


  def workout_profile(username)
    url = "https://www.instagram.com/#{username}/"
    @username = username.downcase
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    element = html_doc.text.strip
    @results = []
    html_doc.search('script').each do |element|
      @results << element
    end

     @instagram = JSON.parse(@results[3].children.text.strip.chomp(";").last(-21))
     @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
     @profile_pic_url =  @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["profile_pic_url"]
     @workouts = []
     @media.each do |post|
      @workouts << post if !post["node"]["edge_media_to_caption"]["edges"].first["node"]["text"].downcase.match('post score').blank?
     end

  end
end
