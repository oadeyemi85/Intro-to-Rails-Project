class TrailTag < ApplicationRecord
  belongs_to :trail
  belongs_to :tag

  validates :trail, :tag, presence: true
  validates :tag_id, uniqueness: { scope: :trail_id }
end
