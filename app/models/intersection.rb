# == Schema Information
#
# Table name: intersections
#
#  id         :integer          not null, primary key
#  latitude   :decimal(, )      not null
#  longitude  :decimal(, )      not null
#  created_at :datetime
#  updated_at :datetime
#

class Intersection < ActiveRecord::Base

  # NORTHEAST = [-122.3462101020676, 37.8123578039731]
  # SOUTHWEST = [-122.62458645470844, 37.698000517492105]
  #
  # def self.within_sf
  #   Intersection.where(
  #     latitude: SOUTHWEST[1]..NORTHEAST[1],
  #     longitude: SOUTHWEST[0]..NORTHEAST[0]
  #   )
  # end

end
