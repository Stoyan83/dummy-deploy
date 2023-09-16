Rails.application.routes.draw do
  resources :ratings, only: %i[new create]
  root 'ratings#new'
end
