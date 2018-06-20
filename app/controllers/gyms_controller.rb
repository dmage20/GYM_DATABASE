class GymsController < ApplicationController

  def index
      @gym = Gym.new

    # if params[:query].present?

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
    # else
      country = Country.find_by_name(params["gym"]["address"].split(",").slice(-1).strip)
      city = City.find_by_name(params["gym"]["address"].split(",")[0].strip)

       @gyms = Gym.joins(:country , :city).where('cities.name' => city.name, 'countries.name' => country.name)

        @markers = @gyms.map do |gym|
        {
          lat: gym.latitude,
          lng: gym.longitude#,
         # infoWindow: { content: render_to_string(partial: "/flats/map_box", locals: { flat: flat }) }
        }
      end
    # end

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
