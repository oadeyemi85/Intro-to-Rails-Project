class Trail < ApplicationRecord
  DIFFICULTIES = %w[Easy Moderate Hard].freeze

  belongs_to :park
  has_one :region, through: :park
  has_many :trail_tags, dependent: :destroy
  has_many :tags, through: :trail_tags
  has_many :trail_activities, dependent: :destroy
  has_many :activities, through: :trail_activities

  validates :name, :description, :surface, :source_name, presence: true
  validates :name, uniqueness: { scope: :park_id, case_sensitive: false }
  validates :difficulty, inclusion: { in: DIFFICULTIES }
  validates :distance_km, numericality: { greater_than: 0, less_than_or_equal_to: 500 }
  validates :elevation_gain_m, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :latitude, numericality: { in: -90..90 }
  validates :longitude, numericality: { in: -180..180 }
end
