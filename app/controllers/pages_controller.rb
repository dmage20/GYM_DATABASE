class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :gyms]

  def home
    @gym = Gym.new

      @gyms = Gym.all.sample(9)


        @markers = @gyms.map do |gym|
        {
          lat: gym.latitude,
          lng: gym.longitude#,
         # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
        }
      end

      # create items for the country profile
      @coutries = Country.order('gyms_count').last(6)


  end
end
