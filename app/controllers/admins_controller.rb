class AdminsController < ApplicationController

  http_basic_authenticate_with name: "admin", password: "getfit", only: [:create]

  def create
    @gym = Gym.find(params[:gym_id])
    @admin = Admin.new(gym_id: params[:gym_id], user_id: current_user.id)
       if @admin.save
      # redirect_to gym_path(@gym)
      respond_to do |format|
        format.html { redirect_to gym_path(@gym) }
        format.js # <-- will render `app/views/bookmarks/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'gyms/show' }
        format.js  # <-- idem
      # render 'gyms/show'
      end
    end
  end

  def destroy

  end

  def index

  end
end
