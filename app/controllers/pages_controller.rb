class PagesController < ApplicationController
  require 'unsplash'
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
      @coutries = Country.order('gyms_count').last(50).sample(6)
      # @cities = []
      #  @coutries.each do |country|
      #   city = country.cities.order('gyms_count').last
      #   # search_results = Unsplash::Photo.search(city.name)
      #   # background = search_results.sample.urls.small
      #   @cities << city
      #  end
      # binding.pry

  end
end
