class IntersectionsController < ApplicationController

  def index
    @intersections = Intersection.offsetted(params[:$offset].to_i)
    render json: @intersections
  end

end
