require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  test "seeds are repeatable and load more than 200 records" do
    Rails.application.load_seed
    counts = [ Region.count, Park.count, Trail.count, Tag.count, Activity.count, TrailTag.count, TrailActivity.count ]

    assert_operator counts.sum, :>=, 200
    assert_operator Trail.count, :>=, 200
    assert_includes Trail.distinct.pluck(:source_name), "Faker-generated demonstration trail catalog"

    Rails.application.load_seed
    assert_equal counts, [ Region.count, Park.count, Trail.count, Tag.count, Activity.count, TrailTag.count, TrailActivity.count ]
  end
end
