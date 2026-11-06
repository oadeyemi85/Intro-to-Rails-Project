class Region < ApplicationRecord
  has_many :parks, dependent: :restrict_with_error
  has_many :trails, through: :parks

  validates :name, :province, :country, :source_name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :latitude, numericality: { in: -90..90 }
  validates :longitude, numericality: { in: -180..180 }
end
