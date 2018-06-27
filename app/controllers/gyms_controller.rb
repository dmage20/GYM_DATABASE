class GymsController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  skip_before_action :authenticate_user!, only: :index

  def show
    @gym = Gym.find(params["id"])

   url_search = "https://www.instagram.com/web/search/topsearch/?context=blended&query=#{@gym.name}"
   user_serialized = open(url_search).read
   @user = JSON.parse(user_serialized)
   @sorted = @user.first[1].sort_by { |each| each["user"]["follower_count"] }
   @profile = @sorted.last
   @username = @profile["user"]["username"]
   # binding.pry
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
     # access here to an array with the photos and information post level
     @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]



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
