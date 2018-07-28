class GymsController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  require 'i18n'
  require 'savon'
  skip_before_action :authenticate_user!, only: [:index, :show]

  def show
    @gyms = []
    @gym = Gym.find(params["id"])
    @gyms << @gym
        @markers = @gyms.map do |gym|
        {
          lat: gym.latitude,
          lng: gym.longitude,
          infoWindow: { content: render_to_string(partial: "/gyms/map_box", locals: { gym: gym }) }
        }
      end
   # search for gym possible instagram ids and pick the one with most followers
   url_search = "https://www.instagram.com/web/search/topsearch/?context=blended&query=#{@gym.name}"
   user_serialized = open(I18n.transliterate(url_search)).read
   @user = JSON.parse(user_serialized)
    if @user["users"].blank?

      @pk =  @user["places"][0]["place"]["location"]["pk"]
      url = "https://www.instagram.com/explore/locations/#{@pk}/#{@gym.name.split[0]}-#{@gym.name.split[1]}/"
      html_file = open(I18n.transliterate(url)).read
      html_doc = Nokogiri::HTML(html_file)
      element = html_doc.text.strip
      @results = []
      html_doc.search('script').each do |element|
        @results << element

        end
      @instagram = JSON.parse(@results[3].children.text.strip.chomp(";").last(-21))
      @media = @instagram["entry_data"]["LocationsPage"][0]["graphql"]["location"]["edge_location_to_media"]["edges"]
      # @user = ""
      # @bio = ""

    else
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
    # puts "------------------------"
    # puts "full name of chosen #{@profile["user"]["full_name"]}"
    # puts "------------------------------"
    # puts "this is the matched #{@user.first[1].each { |each| puts each["user"]["full_name"].match(@gym.name)}}"
    # puts "----------------------------"

     @instagram = JSON.parse(@results[3].children.text.strip.chomp(";").last(-21))
     # access here to profile information
     @user = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]
     @bio = @user["biography"]
     # access here to an array with the photos and information post level
     @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]

    # binding.pry if !@user["users"].blank?
    end
     # google section
     # get google places id
     url_places = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{@gym.name} #{@gym.city.name}&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,place_id,geometry&key=#{ENV['GOOGLE_API_SERVER_KEY']}"
     places_serialized = open(I18n.transliterate(url_places)).read
     @places = JSON.parse(places_serialized)
     # binding.pry
     if !@places["candidates"].blank?
      place_id = @places["candidates"][0]["place_id"]
      url_details = "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&fields=name,rating,formatted_address,formatted_phone_number,opening_hours&key=#{ENV['GOOGLE_API_SERVER_KEY']}"

     # "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&fields=name,rating,formatted_phone_number,formatted_address,opening_hours&key=#{ENV['GOOGLE_API_BROWSER_KEY']}"
      details_serialized = open(url_details).read
      @details = JSON.parse(details_serialized)
    end
     # @hours is an array with days

     if !@details.blank? && !@details["result"]["opening_hours"].blank?
     @hours = @details["result"]["opening_hours"]["weekday_text"]
     @open_now = @details["result"]["opening_hours"]["open_now"]
     @formatted_address = @details["result"]["formatted_address"]
     @formatted_phone_number = @details["result"]["formatted_phone_number"]
      end
     # true or false

    # url = "https://www.instagram.com/web/search/topsearch/?context=blended&query=#{@gym.name}"

    # @profile_pic = @profile["user"]["profile_pic_url"]

    # @second_url = "https://www.instagram.com/#{@username}/?__a=1"
    # second_serialized = open(second_url).read
    # @instagram = JSON.parse(second_serialized)
    # class_schedule

  end


  def index
      @gym = Gym.new
    if params.has_key?(:city) & !params["state"].blank?
      @gyms = Gym.joins(:country , :city).where('cities.name' => params["city"], 'countries.name' => params["country"], 'cities.state' => params["state"])
    elsif params.has_key?(:city) && params["state"].blank?
      @gyms = Gym.joins(:country , :city).where('cities.name' => params["city"], 'countries.name' => params["country"])
      # binding.pry
      # @gyms = Gym.joins(:city).where('cities.name' => params["profile_card"])
      # @gyms = Gym.near(params["profile_card"],10)

    # the first search term is tied to the banner search button
    elsif !params["gym"].blank? && !params["gym"]["address"].blank?
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

  # def class_schedule
  #   # Setup credentials
  #   site_ids = { 'int' => -99 } # Use your site ID here
  #   source_credentials = {
  #     'SourceName' => 'gngbase',
  #     'Password' => 'VtA5jsaF3ShKtoaw2e2/tBepZLU=',
  #     'SiteIDs' => site_ids
  #   }
  #   user_credentials = {
  #     'Username' => 'Siteowner',
  #     'Password' => 'apitest1234',
  #     'SiteIDs' => site_ids
  #   }
  #     #######################
  #     ## Standard API call ##
  #     #######################

  #     # Create Savon client using default settings
  #     http_client = Savon.client(wsdl: "https://api.mindbodyonline.com/0_5/ClassService.asmx?WSDL")

  #     # Create request and package it for the call
  #     http_request = {
  #       'SourceCredentials' => source_credentials,
  #       'UserCredentials' => user_credentials
  #     }
  #     params = { 'Request' => http_request }

  #     # Fetch current day's classes via GetClasses
  #     # https://developers.mindbodyonline.com/Documentation/ClassService?version=v5.0
  #     result = http_client.call(:get_classes, message: params)

  #     # Parse class data
  #     class_data = result.body.dig(:get_classes_response, :get_classes_result, :classes, :class)

  #     formatted_classes = class_data.map do |scheduled_class|
  #       {
  #         name: scheduled_class.dig(:class_description, :name),
  #         description: scheduled_class.dig(:class_description, :description),
  #         start_date_time: scheduled_class[:start_date_time].strftime("%B %d, %Y %l:%M%P"),
  #         end_date_time: scheduled_class[:end_date_time].strftime("%B %d, %Y %l:%M%P")
  #       }
  #     end

  #     # Display class info
  #     puts "Class schedule:"
  #     @location_schedule = []
  #     formatted_classes.each do |formatted_class|
  #       # puts "Name: #{formatted_class[:name]} (#{formatted_class[:start_date_time]} - #{formatted_class[:end_date_time]})"
  #       # puts "Description: #{formatted_class[:description]}"
  #       # puts "-----------------------------------------------------------"
  #       each_class = {
  #       "class_name" => "#{formatted_class[:name]}",
  #       "start_date_time" => "#{formatted_class[:start_date_time]}",
  #       "end_date_time" => "#{formatted_class[:end_date_time]}",
  #       "description" => "#{formatted_class[:description]}"
  #     }
  #     @location_schedule << each_class

  #     end

  # end
