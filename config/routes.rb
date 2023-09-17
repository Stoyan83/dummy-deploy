# frozen_string_literal: true

Rails.application.routes.draw do
  resources :ratings, only: %i[new create]
  root 'ratings#new'
end
