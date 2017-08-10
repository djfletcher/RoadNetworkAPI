# == Schema Information
#
# Table name: road_points
#
#  id           :integer          not null, primary key
#  latitude     :decimal(, )      not null
#  longitude    :decimal(, )      not null
#  road_edge_id :integer          not null
#

class RoadPoint < ActiveRecord::Base
end
