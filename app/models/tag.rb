class Tag < ApplicationRecord
  has_many :trail_tags, dependent: :destroy
  has_many :trails, through: :trail_tags

  validates :name, :description, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
