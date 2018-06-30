class GymsController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  skip_before_action :authenticate_user!, only: :index

  def show
    @gym = Gym.find(params["id"])
   # search for gym possible instagram ids and pick the one with most followers
   url_search = "https://www.instagram.com/web/search/topsearch/?context=blended&query=#{@gym.name}"
   user_serialized = open(url_search).read
   @user = JSON.parse(user_serialized)
   @sorted = @user.first[1].sort_by { |each| each["user"]["follower_count"] }
   @profile = @sorted.last
   @username = @profile["user"]["username"]
   # search for gym details
   url = "https://www.instagram.com/#{@username}/"

   html_file = open(url).read
   html_doc = Nokogiri::HTML(html_file)
   element = html_doc.text.strip
   @results = []
   html_doc.search('script').each do |element|
    @results << element
    # puts element.text.strip
    # puts element.attribute('href')

    end

     @instagram = JSON.parse(@results[3].children.text.strip.chomp(";").last(-21))
     # access here to profile information
     @user = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]
     @bio = @user["biography"]
     # access here to an array with the photos and information post level
     @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
     # google section
     # get google places id
     url_places = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{@gym.name} #{@gym.city.name}&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,place_id,geometry&key=#{ENV['GOOGLE_API_BROWSER_KEY']}"
     places_serialized = open(url_places).read
     @places = JSON.parse(places_serialized)
     place_id = @places["candidates"][0]["place_id"]
     url_details = "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&fields=name,rating,formatted_address,formatted_phone_number,opening_hours&key=#{ENV['GOOGLE_API_BROWSER_KEY']}"

     # "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&fields=name,rating,formatted_phone_number,formatted_address,opening_hours&key=#{ENV['GOOGLE_API_BROWSER_KEY']}"

     details_serialized = open(url_details).read
     @details = JSON.parse(details_serialized)
     # @hours is an array with days

     if !@details["result"]["opening_hours"].blank?
     @hours = @details["result"]["opening_hours"]["weekday_text"]
     @open_now = @details["result"]["opening_hours"]["open_now"]
      end
     @formatted_address = @details["result"]["formatted_address"]
     @formatted_phone_number = @details["result"]["formatted_phone_number"]
     # true or false

    # url = "https://www.instagram.com/web/search/topsearch/?context=blended&query=#{@gym.name}"

    # @profile_pic = @profile["user"]["profile_pic_url"]

    # @second_url = "https://www.instagram.com/#{@username}/?__a=1"
    # second_serialized = open(second_url).read
    # @instagram = JSON.parse(second_serialized)

  end



  def index
      @gym = Gym.new

    # the first search term is tied to the banner search button
    if !params["gym"].blank? && !params["gym"]["address"].blank?
        @gyms = Gym.near(params["gym"]["address"],10)

    else

      @city = City.all.sample
      @gyms = Gym.joins(:city).where('cities.name' => @city.name)
    end


        @markers = @gyms.map do |gym|
        {
          lat: gym.latitude,
          lng: gym.longitude,
          infoWindow: { content: render_to_string(partial: "/gyms/map_box", locals: { gym: gym }) }
        }
      end
    #   sql_query = " \
    #     cities.name @@ :query \
    #   "
    #   @gyms = Gym.joins(:city).where(sql_query, query: "%#{params[:query]}%")

    #     # @flats = Flat.where.not(latitude: nil, longitude: nil)
    #     @markers = @gyms.map do |gym|
    #     {
    #       lat: gym.latitude,
    #       lng: gym.longitude#,
    #      # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
    #     }
    #   end
      # country = Country.find_by_name(params["gym"]["address"].split(",").slice(-1).strip)
      # city = City.find_by_name(params["gym"]["address"].split(",")[0].strip)
      # binding.pry
      #  @gyms = Gym.joins(:country , :city).where('cities.name' => city.name, 'countries.name' => country.name)

      #   @markers = @gyms.map do |gym|
      #   {
      #     lat: gym.latitude,
      #     lng: gym.longitude#,
      #    # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
      #   }
      # end

    # end leve this out
        # Second Method of searching - relying on google

  end
end


        # additional search params
        # OR gyms.name @@ :query \
        # OR gyms.address @@ :query \


        # current working query

      # city_id = City.where("name ILIKE ?", "%#{params[:query]}%")
      # @gyms = Gym.where(city: city_id)

# Category.joins(:articles)
# time_range = (Time.now.midnight - 1.day)..Time.now.midnight
# Client.joins(:orders).where('orders.created_at' => time_range)

# sql_query = Country.where(name: "Colombia")
# Gym.joins(:country).where('countries.name' => "Colombia")
