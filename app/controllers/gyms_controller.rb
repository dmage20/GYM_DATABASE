class GymsController < ApplicationController

  def index

    if params[:query].present?
      sql_query = " \
        gyms.name @@ :query \
        OR gyms.address @@ :query \
        OR cities.name @@ :query \
      "
      @gyms = Gym.joins(:city).where(sql_query, query: "%#{params[:query]}%")

        # @flats = Flat.where.not(latitude: nil, longitude: nil)
        @markers = @gyms.map do |gym|
        {
          lat: gym.latitude,
          lng: gym.longitude#,
         # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
        }
      end
    else
      @gyms = Gym.all
    end


  end
end



        # additional search params


        # current working query

      # city_id = City.where("name ILIKE ?", "%#{params[:query]}%")
      # @gyms = Gym.where(city: city_id)

# Category.joins(:articles)
# time_range = (Time.now.midnight - 1.day)..Time.now.midnight
# Client.joins(:orders).where('orders.created_at' => time_range)

# sql_query = Country.where(name: "Colombia")
# Gym.joins(:country).where('countries.name' => "Colombia")
