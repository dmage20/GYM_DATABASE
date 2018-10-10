class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: :show


  def create
    @gym = Gym.find(params[:gym_id])
    @bookmark = Bookmark.new(gym_id: params[:gym_id], user_id: current_user.id)
    @bookmark.gym = @gym
    if @bookmark.save
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
        @gym = Gym.find(params[:gym_id])
        @bookmark = Bookmark.where(gym_id: params[:gym_id], user_id: current_user.id)
        if @bookmark.destroy_all
          # redirect_to gym_path(@gym)
          respond_to do |format|
          format.html { redirect_to gym_path(@gym) }
          format.js  # <-- will render `app/views/bookmarks/create.js.erb`
          end
        end
  end

  def show

  end

end
