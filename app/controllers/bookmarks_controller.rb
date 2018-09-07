class BookmarksController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def new

  end

  def create

  end

  def destroy

  end

  def show

  end
end
