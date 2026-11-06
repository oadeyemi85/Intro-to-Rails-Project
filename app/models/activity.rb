class Activity < ApplicationRecord
  has_many :trail_activities, dependent: :destroy
  has_many :trails, through: :trail_activities

  validates :name, :description, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
