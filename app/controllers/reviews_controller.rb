class ReviewsController < ApplicationController
  def create
    @gym = Gym.find(params[:gym_id])
    @review = Review.new(review_params)
    @review.gym = @gym
    @review.user = current_user
    if @review.save
      # redirect_to gym_path(@gym)
      respond_to do |format|
        format.html { redirect_to gyms_path(@gyms) }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      # render 'gyms/show'
      respond_to do |format|
        format.html { render 'gyms/show' }
        format.js  # <-- idem
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end
end
