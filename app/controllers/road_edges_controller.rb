class RoadEdgesController < ApplicationController

  def index
    @road_edges = RoadEdge.all_pairs
    render json: @road_edges
  end

end
