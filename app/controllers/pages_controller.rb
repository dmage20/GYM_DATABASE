class PagesController < ApplicationController
  require 'unsplash'
  require 'open-uri'
  require 'nokogiri'
  require 'i18n'
  skip_before_action :authenticate_user!, only: [:home, :gyms]

  def crossfitwods
    wod_profile("thecrossfitmayhem")
  end

  def home
    @gym = Gym.new

      @gyms = Gym.all.sample(6)


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
      @cities = City.order('gyms_count').last(50).sample(6)

      # call the mayhem_profile function and pass it crossfit mayhem
      mayhem_profile("thecrossfitmayhem")
      wod_profile("thecrossfitmayhem")
      # add unsplash image to each city in @cities
      @photograpers = []
      @unsplash_cities = @cities.each do |city|
      search_results = Unsplash::Photo.search(city.name, page = 1, per_page = 10, orientation = "landscape").first(3).sample
      # url = "https://api.unsplash.com/search/photos?client_id=7f4b6697803bdc15bc73567bde8958a895445fbf1b0af13352b8169bf99b84b3&query=#{city.name}&per_page=10"
      # response = open(I18n.transliterate(url)).read
      # @response_parsed = JSON.parse(response)
      # chosen_unsplash = @response_parsed["results"].first(5).sample if !@response_parsed["results"].blank?
      # city.url =  chosen_unsplash["urls"]["small"] if !@response_parsed["results"].blank?
      chosen_unsplash = search_results.urls.small if !search_results.blank?
      city.url = chosen_unsplash if !chosen_unsplash.blank?
      photograper = search_results.user.username if !chosen_unsplash.blank?
      photograper_name = search_results.user.name if !chosen_unsplash.blank?
      @photograpers << photograper << photograper_name
      end
  end

    # helper_method :unsplash


  def mayhem_profile(username)
    url = "https://www.instagram.com/#{username}/"
    @username = username.downcase
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    element = html_doc.text.strip
    @results = []
    html_doc.search('script').each do |element|
      @results << element
    end

     @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
     @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
     @profile_pic_url =  @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["profile_pic_url"]
     @workouts = []
     @media.each do |post|
      @workouts << post if !post["node"]["edge_media_to_caption"]["edges"].first["node"]["text"].downcase.match('post score').blank?
     end
  end

  def wod_profile(username)
    url = "https://www.instagram.com/#{username}/"
    @username = username.downcase
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    element = html_doc.text.strip
    @results = []
    html_doc.search('script').each do |element|
      @results << element
    end

     @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
     @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
     @profile_pic_url =  @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["profile_pic_url"]
    @workouts = []
    @media.each { |each| @workouts << each if !each["node"]["edge_media_to_caption"]["edges"].first["node"]["text"].downcase.match('post score').blank?
    }
    @array_of_wods = []
    @workouts.each do |dumb|
    wod = OpenStruct.new
    wod.id = dumb["node"]["id"]
    wod.type = dumb["node"]["__typename"]
    wod.caption = dumb["node"]["edge_media_to_caption"]['edges'][0]['node']['text'] if !dumb["node"]['edge_media_to_caption']['edges'].blank?
    wod.time = Time.at(dumb["node"]['taken_at_timestamp']).strftime("%B %d, %Y")
    wod.picture = OpenStruct.new
    wod.picture.small = dumb["node"]["thumbnail_resources"][0]["src"]
    wod.picture.medium = dumb["node"]["thumbnail_resources"][1]["src"]
    wod.picture.large = dumb["node"]["thumbnail_resources"][2]["src"]
    wod.picture.xl = dumb["node"]["thumbnail_resources"][3]["src"]
    wod.picture.xxl = dumb["node"]["thumbnail_resources"][4]["src"]
    wod.likes = dumb["node"]['edge_liked_by']['count']
    wod.owner = OpenStruct.new
    wod.owner.id = dumb["node"]['owner']['id']
    wod.owner.username = @profile['user']['username'] if ! @profile.blank?
    wod.owner.profile_pic = @profile['user']['profile_pic_url'] if ! @profile.blank?
    wod.owner.follower_count = @profile['user']['follower_count'] if ! @profile.blank?
    wod.owner.follower_count_text = @profile['user']['byline'] if ! @profile.blank?
    @array_of_wods << wod
    end
  end
  # def wod_profile(username)
  #   url = "https://www.instagram.com/#{username}/"
  #   @username = username.downcase
  #   html_file = open(url).read
  #   html_doc = Nokogiri::HTML(html_file)
  #   element = html_doc.text.strip
  #   @results = []
  #   html_doc.search('script').each do |element|
  #     @results << element
  #   end

  #    @instagram = JSON.parse(@results[4].children.text.strip.chomp(";").last(-21))
  #    @media = @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
  #    @profile_pic_url =  @instagram["entry_data"]["ProfilePage"][0]["graphql"]["user"]["profile_pic_url"]
  #    # @workouts = []
  #    # @media.each do |post|
  #    #  binding.pry
  #    #  @workouts << post if !post["node"]["edge_media_to_caption"]["edges"].first["node"]["text"].downcase.match('post score').blank?
  #    # end
  #   @array_of_posts = []
  #   @media.each do |dumb|
  #   post = OpenStruct.new
  #   post.id = dumb["node"]["id"]
  #   post.type = dumb["node"]["__typename"]
  #   post.caption = dumb["node"]["edge_media_to_caption"]['edges'][0]['node']['text'] if !dumb["node"]['edge_media_to_caption']['edges'].blank?
  #   post.time = Time.at(dumb["node"]['taken_at_timestamp']).strftime("%B %d, %Y")
  #   post.picture = OpenStruct.new
  #   post.picture.small = dumb["node"]["thumbnail_resources"][0]["src"]
  #   post.picture.medium = dumb["node"]["thumbnail_resources"][1]["src"]
  #   post.picture.large = dumb["node"]["thumbnail_resources"][2]["src"]
  #   post.picture.xl = dumb["node"]["thumbnail_resources"][3]["src"]
  #   post.picture.xxl = dumb["node"]["thumbnail_resources"][4]["src"]
  #   post.likes = dumb["node"]['edge_liked_by']['count']
  #   post.owner = OpenStruct.new
  #   post.owner.id = dumb["node"]['owner']['id']
  #   post.owner.username = @profile['user']['username'] if ! @profile.blank?
  #   post.owner.profile_pic = @profile['user']['profile_pic_url'] if ! @profile.blank?
  #   post.owner.follower_count = @profile['user']['follower_count'] if ! @profile.blank?
  #   post.owner.follower_count_text = @profile['user']['byline'] if ! @profile.blank?
  #   @array_of_posts << post
  #   end
  # end

end
