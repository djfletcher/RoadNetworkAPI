# == Schema Information
#
# Table name: road_edges
#
#  id               :integer          not null, primary key
#  intersection1_id :integer          not null
#  intersection2_id :integer          not null
#  street_name      :string
#  created_at       :datetime
#  updated_at       :datetime
#

class RoadEdge < ActiveRecord::Base

  

end
