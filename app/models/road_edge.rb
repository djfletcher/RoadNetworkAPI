# == Schema Information
#
# Table name: road_edges
#
#  id               :integer          not null, primary key
#  intersection1_id :integer          not null
#  intersection2_id :integer          not null
#  street_name      :string
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


  def self.offset(num_rows)
    RoadEdge.offset(num_rows).limit(5000)
  end

  def self.offset_pairs(num_rows)
    RoadEdge.offset(num_rows).limit(5000).map do |edge|
      edge.intersections.map(&:id)
    end
  end

  def self.offset_pairs_by_id(num_rows)
    RoadEdge.offset(num_rows).limit(5000).map(&:intersection_ids)
  end

  #
  # def self.all_pairs
  #   all_intersections = Intersection.find_each.index_by(&:id)
  #   RoadEdge.find_each.map do |r|
  #     { r.id => [all_intersections[r.intersection1_id], all_intersections[r.intersection2_id]] }
  #   end
  # end

  def intersections
    [self.intersection1, self.intersection2]
  end

  def intersection_ids
    [self.intersection1_id, self.intersection2_id]
  end

end
