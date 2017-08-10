Rails.application.routes.draw do
  resources :intersections, only: [:index]
  resources :road_edges, only: [:index]
end
