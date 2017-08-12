class RoadEdgesController < ApplicationController

  def index
    @road_edges = RoadEdge.offset_pairs(params[:$offset].to_i)
    render json: @road_edges
  end

end
