# == Schema Information
#
# Table name: road_points
#
#  id           :integer          not null, primary key
#  latitude     :decimal(10, 6)   not null
#  longitude    :decimal(10, 6)   not null
#  road_edge_id :integer          not null
#

class RoadPoint < ActiveRecord::Base

  belongs_to :road_edge

end
