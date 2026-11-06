class Park < ApplicationRecord
  belongs_to :region
  has_many :trails, dependent: :restrict_with_error

  validates :name, :park_type, :description, :source_name, presence: true
  validates :name, uniqueness: { scope: :region_id, case_sensitive: false }
  validates :latitude, numericality: { in: -90..90 }
  validates :longitude, numericality: { in: -180..180 }
  validates :website_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
end
