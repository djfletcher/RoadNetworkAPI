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

  has_many :road_points

  belongs_to :intersection1,
    class_name: :Intersection,
    foreign_key: :intersection1_id,
    primary_key: :id

  belongs_to :intersection2,
    class_name: :Intersection,
    foreign_key: :intersection2_id,
    primary_key: :id

  def self.all_pairs
    RoadEdge.find_each.map do |r|
      [Intersection.find_by_id(r.intersection1_id), Intersection.find_by_id(r.intersection1_id)]
    end
  end
  #
  # def self.all_pairs
  #   all_intersections = Intersection.find_each.index_by(&:id)
  #   RoadEdge.find_each.map do |r|
  #     [all_intersections[r.intersection1_id], all_intersections[r.intersection2_id]]
  #   end
  # end

  def intersections
    [self.intersection1, self.intersection2]
  end

end
