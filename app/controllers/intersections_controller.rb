class IntersectionsController < ApplicationController

  def index
    @intersections = Intersection.within_sf
    render json: @intersections
  end

end
