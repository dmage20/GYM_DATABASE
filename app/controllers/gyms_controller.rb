class GymsController < ApplicationController
  require 'open-uri'
  require 'nokogiri'
  require 'i18n'
  require 'savon'
  # require 'google_places'
  skip_before_action :authenticate_user!, only: [:index, :show]

  def media_hash_to_object(array_of_hashes)
    @array_of_posts = []
    array_of_hashes.each do |dumb|
    post = OpenStruct.new
    post.id = dumb["node"]["id"]
    post.type = dumb["node"]["__typename"]
    post.caption = dumb["node"]["edge_media_to_caption"]['edges'][0]['node']['text'] if !dumb["node"]['edge_media_to_caption']['edges'].blank?
    post.time = Time.at(dumb["node"]['taken_at_timestamp']).strftime("%B %d, %Y")
    post.picture = OpenStruct.new
    post.picture.small = dumb["node"]["thumbnail_resources"][0]["src"]
    post.picture.medium = dumb["node"]["thumbnail_resources"][1]["src"]
    post.picture.large = dumb["node"]["thumbnail_resources"][2]["src"]
    post.picture.xl = dumb["node"]["thumbnail_resources"][3]["src"]
    post.picture.xxl = dumb["node"]["thumbnail_resources"][4]["src"]
    post.likes = dumb["node"]['edge_liked_by']['count']
    post.owner = OpenStruct.new
    post.owner.id = dumb["node"]['owner']['id']
    post.owner.username = @profile['user']['username'] if ! @profile.blank?
    post.owner.profile_pic = @profile['user']['profile_pic_url'] if ! @profile.blank?
    post.owner.follower_count = @profile['user']['follower_count'] if ! @profile.blank?
    post.owner.follower_count_text = @profile['user']['byline'] if ! @profile.blank?
    @array_of_posts << post
    end

  end

  def instagram_web_search(gym_instance)
    url_search = "https://www.instagram.com/web/search/topsearch/?context=blended&query=#{@gym.name}"
    user_serialized = open(I18n.transliterate(url_search)).read
    @user = JSON.parse(user_serialized)
  end

  def instagram_user_method(instagram_web_search_result)
      @sorted = @user.first[1].sort_by { |each| each["user"]["follower_count"] }
      @profile = @sorted.last
      @username = @profile["user"]["username"]
      @username = @gym.username if !@gym.username.blank?
   # search for gym details
      url = "https://www.instagram.com/#{@username}/"

      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      element = html_doc.text.strip
      @results = []
      html_doc.search('script').each do |element|
        @results << element
      end
      if @results[4].children.text.strip.chomp(";").last(-21) == "oaded(window._sharedData)"

        @instagram = JSON.parse(@results[3].children.text.strip.chomp(";").last(-21))
      else
        @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
      end
      # @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
      @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
      media_hash_to_object(@media)
      @user = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]
  end

  def instagram_place_method(instagram_web_search_result)

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
      @media = @instagram["entry_data"]["LocationsPage"][0]["graphql"]["location"]["edge_location_to_media"]["edges"].first(12)
      media_hash_to_object(@media)
  end

  def instagram_hashtag_method(instagram_web_search_result)

      hashtag = @user["hashtags"][0]["hashtag"]["name"]
      url = "https://www.instagram.com/explore/tags/#{hashtag}/"
      html_file = open(I18n.transliterate(url)).read
      html_doc = Nokogiri::HTML(html_file)
      element = html_doc.text.strip
      @results = []
      html_doc.search('script').each do |element|
        @results << element

        end
      @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
      @media =  @instagram["entry_data"]["TagPage"][0]["graphql"]["hashtag"]["edge_hashtag_to_media"]["edges"].first(12)
      media_hash_to_object(@media)
  end




  def show
    @score = Score.new
    @wod = Wod.new
    @wods = Wod.where(gym_id: params["id"])
    @admin = Admin.new
    @bookmark = Bookmark.new
    @review = Review.new
    @events = Event.where(gym_id: params["id"])
    @gyms = []
    @gym = Gym.find(params["id"])
    @gyms << @gym
        @markers = @gyms.map do |gym|
        {
          lat: gym.latitude,
          lng: gym.longitude
          # ,
          # infoWindow: { content: render_to_string(partial: "/gyms/map_box", locals: { gym: gym }) }
        }
      end
# -----search for gym possible instagram ids and pick the one with most followers
    instagram_web_search(@gym)
# -------------- initial get to instagram above with gym name --------------
  # !@gym.username.blank?
  if !@gym.username.present? && !@gym.igplace.present? && !@gym.hashtag.present?

    if !@user["users"].blank?

    instagram_user_method(@user)
# --------------work with users above this line --------------------
    elsif !@user["places"].blank?
    instagram_place_method(@user)
      #
 # --------------work with places above this line --------------------
    else
    instagram_hashtag_method(@user)
    end
#--------------line where three options converge-----------------------
  elsif @gym.username.present?
    @username = @gym.username
   # search for gym details
      url = "https://www.instagram.com/#{@username}/"

      html_file = open(url).read
      html_doc = Nokogiri::HTML(html_file)
      element = html_doc.text.strip
      @results = []
      html_doc.search('script').each do |element|
        @results << element
      end
      @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
      @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
      media_hash_to_object(@media)
      @user = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]
      @profile = @instagram["entry_data"]["ProfilePage"][0]["graphql"]
  elsif @gym.igplace.present?
      @pk = @gym.igplace
      url = "https://www.instagram.com/explore/locations/#{@pk}/#{@gym.name.split[0]}-#{@gym.name.split[1]}/"
      html_file = open(I18n.transliterate(url)).read
      html_doc = Nokogiri::HTML(html_file)
      element = html_doc.text.strip
      @results = []
      html_doc.search('script').each do |element|
        @results << element

        end
      @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
      @media = @instagram["entry_data"]["LocationsPage"][0]["graphql"]["location"]["edge_location_to_media"]["edges"].first(12)
      media_hash_to_object(@media)
  elsif @gym.hashtag.present?
      hashtag = @gym.hashtag
      url = "https://www.instagram.com/explore/tags/#{hashtag}/"
      html_file = open(I18n.transliterate(url)).read
      html_doc = Nokogiri::HTML(html_file)
      element = html_doc.text.strip
      @results = []
      html_doc.search('script').each do |element|
        @results << element

        end
      @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
      @media =  @instagram["entry_data"]["TagPage"][0]["graphql"]["hashtag"]["edge_hashtag_to_media"]["edges"].first(12)
      media_hash_to_object(@media)
  end
      @bio = @user["biography"]
     # access here to an array with the photos and information post level
# ------------google places section -------------------------------------
     @client = GooglePlaces::Client.new(ENV['GOOGLE_API_SERVER_KEY'])
     spot = @client.spots(@gym.latitude, @gym.longitude, :name => @gym.name)
     if spot.blank?
       spot = @client.spots_by_query("#{@gym.name} near #{@gym.city.name} #{@gym.city.state.to_s}")
     end
     if !spot.blank?
      spot_id = spot.first.place_id
      @spot = @client.spot(spot_id)
      if !@spot.opening_hours.blank?
        @hours = @spot.opening_hours["weekday_text"]
        @open_now = @spot.opening_hours["open_now"]
      end

     end
# -------------------------------------------------
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
          if @gyms.blank?
            @gyms = Gym.near(params["gym"]["address"],30)
          end
          if @gyms.blank? || params["gym"]["address"].split.count == 1
            @gyms = Gym.joins(:country).where('countries.name' => params["gym"]["address"]).first(30)
          end

    else
      @city = City.all.sample
      @gyms = Gym.joins(:city).where('cities.name' => @city.name)

    end


        @markers = @gyms.map do |gym|
        {
          lat: gym.latitude,
          lng: gym.longitude,
          infoWindow: render_to_string(partial: "/gyms/map_box", locals: { gym: gym })
          # infoWindow: { content: render_to_string(partial: "/gyms/map_box", locals: { gym: gym }) }
        }
      end
  end
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


