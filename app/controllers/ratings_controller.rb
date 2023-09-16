class RatingsController < ApplicationController
  def new
    @rating = Rating.new
    @average_rating = Rating.average_rating
  end

  def create
    @rating = Rating.new(rating_params)
    if @rating.save
      flash[:success] = 'Rating was successfully created.'
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:value)
  end
end
