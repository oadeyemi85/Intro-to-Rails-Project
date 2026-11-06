class TrailActivity < ApplicationRecord
  belongs_to :trail
  belongs_to :activity

  validates :trail, :activity, presence: true
  validates :activity_id, uniqueness: { scope: :trail_id }
end
