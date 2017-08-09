Rails.application.routes.draw do
  resources :intersections, only: [:index]
end
