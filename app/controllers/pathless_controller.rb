class PathlessController < ApplicationController

  def index
    msg = {
      status: 303,
      message: "Please try any of the following urls: 'http://road-network-api.herokuapp.com/intersections', 'http://road-network-api.herokuapp.com/road_edges'" 
    }
    render json: msg
  end

end
