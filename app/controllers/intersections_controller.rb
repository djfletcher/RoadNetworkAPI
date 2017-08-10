class IntersectionsController < ApplicationController

  def index
    @intersections = Intersection.all
    render json: @intersections
  end

end
