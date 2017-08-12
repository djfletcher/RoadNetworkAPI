class IntersectionsController < ApplicationController

  def index
    @intersections = Intersection.offset(params[:$offset].to_i)
    render json: @intersections
  end

end
