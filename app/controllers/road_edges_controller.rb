class RoadEdgesController < ApplicationController

  def index
    @road_edges = RoadEdge.offsetted(params[:$offset].to_i)
    render json: @road_edges
  end

end
