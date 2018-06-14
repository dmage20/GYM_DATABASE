class GymsController < ApplicationController

  def index

    if params[:query].present?
      sql_query = " \
        gyms.name @@ :query \
        OR gyms.address @@ :query \
        OR countries.name @@ :query \
      "
      @gyms = Gym.joins(:country).where(sql_query, query: "%#{params[:query]}%")
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
