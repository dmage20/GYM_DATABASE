class MainController < ApplicationController
  def search
      @users = User.where("name ILIKE ?", "%#{params[:query]}%")
    # render json: {users:[]}
      respond_to do |format|
      format.html {}
      format.json {
        @users = @users.limit(5)
      }
    end
  end

end
