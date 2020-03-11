class Status < ActiveRecord::Base
  has_many :point_of_interests
  attr_accessible :name

  def self.names_collection
    Status.all.map { |s| [s.name, s.id] }
  end
end
