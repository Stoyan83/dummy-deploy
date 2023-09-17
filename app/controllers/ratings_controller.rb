# frozen_string_literal: true

class RatingsController < ApplicationController
  before_action :set_average_rating, only: [:new]

  def new
    @rating = Rating.new
  end

  def create
    @rating = Rating.new(rating_params)

    if @rating.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:value)
  end

  def set_average_rating
    @average_rating = Rating.average_rating.presence || 0
  end
end
