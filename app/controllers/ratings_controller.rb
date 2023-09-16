class RatingsController < ApplicationController
  before_action :set_average_rating, only: [:new]

  def new
    @rating = Rating.new
  end

  def create
    @rating = Rating.create!(rating_params)
    flash[:success] = 'Rating was successfully created.'
    redirect_to root_path
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  private

  def rating_params
    params.require(:rating).permit(:value)
  end

  def set_average_rating
    @average_rating = Rating.average_rating
  end
end
