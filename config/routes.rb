Rails.application.routes.draw do
  root to: 'pathless#index'
  resources :intersections, only: [:index]
  resources :road_edges, only: [:index]
end
