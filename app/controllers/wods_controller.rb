class WodsController < ApplicationController
  # before_action :set_wod, only: [:show, :edit, :update, :destroy]

  def index
    @gym = Gym.find(params["gym_id"])
    @wods = Wod.where(gym_id: params["gym_id"])

  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @gym = Gym.find(params[:gym_id])
    @wod = Wod.new(wod_params)
    @wod.gym = @gym
    @wod.user_id = current_user.id
    if @wod.save
      # redirect_to gym_path(@gym)
      respond_to do |format|
        format.html { redirect_to gyms_path(@gyms) }
        format.js  # <-- will render `app/views/wods/create.js.erb`
      end
    else
      # render 'gyms/show'
      respond_to do |format|
        format.html { render 'gyms/show' }
        format.js  # <-- idem
      end
    end

  end

  def update
  end

  def destroy
  end

  private
    def set_wod
      @wod = Wod.find(params[:id])
    end

    def wod_params
      params.require(:wod).permit(:body)
    end

end
