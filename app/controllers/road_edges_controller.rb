class RoadEdgesController < ApplicationController

  def index
    @road_edges = RoadEdge.all
    render json: @road_edges
  end

end
