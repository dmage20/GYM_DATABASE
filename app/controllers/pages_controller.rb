class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :gyms]

  def home
  end
end
