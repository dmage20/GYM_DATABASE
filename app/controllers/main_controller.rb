class MainController < ApplicationController
  # before_action :force_json, only: :search
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


  # private
  # def force_json
  #   request.format = :json

  # end
end
