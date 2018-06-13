class GymsController < ApplicationController

  def index

    if params[:query].present?
      sql_query = " \
        country.id @@ :query \
      "
      @gyms = Gym.joins(:country).where(sql_query, query: "%#{params[:query]}%")
    else
      @gyms = Gym.all
    end

  end
end



        # additional search params
        # OR gyms.name @@ :query \
        # OR gyms.address @@ :query \

        # current working query

      # city_id = City.where("name ILIKE ?", "%#{params[:query]}%")
      # @gyms = Gym.where(city: city_id)
