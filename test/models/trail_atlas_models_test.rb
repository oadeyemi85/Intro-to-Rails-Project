require "test_helper"

class TrailAtlasModelsTest < ActiveSupport::TestCase
  setup do
    @region = Region.create!(
      name: "Algonquin",
      province: "Ontario",
      country: "Canada",
      source_name: "Test gazetteer",
      latitude: 45.8,
      longitude: -78.3
    )
    @park = Park.create!(
      region: @region,
      name: "Pine Park",
      park_type: "Provincial park",
      description: "A sample park for model tests.",
      source_name: "Test park data",
      latitude: 45.8,
      longitude: -78.3
    )
    @trail = Trail.create!(
      park: @park,
      name: "Maple Loop",
      description: "A sample route through the woods.",
      difficulty: "Easy",
      surface: "Dirt",
      distance_km: 2.5,
      elevation_gain_m: 25,
      source_name: "Test trail data",
      latitude: 45.8,
      longitude: -78.3
    )
    @tag = Tag.create!(name: "Waterfall", description: "A waterfall feature.")
    @activity = Activity.create!(name: "Hiking", description: "A hiking activity.")
  end

  test "region, park, and trail associations are navigable" do
    assert_equal [ @park ], @region.parks
    assert_equal [ @trail ], @park.trails
    assert_equal @region, @trail.region
  end

  test "trails have many tags and activities through join models" do
    @trail.tags << @tag
    @trail.activities << @activity

    assert_equal [ @trail ], @tag.trails
    assert_equal [ @trail ], @activity.trails
  end

  test "region and trail validations reject invalid records" do
    assert_not Region.new(name: "Invalid", latitude: 91, longitude: 0, source_name: "Test").valid?
    assert_not Trail.new(park: @park, name: "Unrated", description: "Missing route details", difficulty: "Impossible",
                         surface: "Dirt", distance_km: 0, elevation_gain_m: -1,
                         source_name: "Test", latitude: 0, longitude: 0).valid?
  end

  test "join models prevent duplicate associations" do
    @trail.tags << @tag
    duplicate = TrailTag.new(trail: @trail, tag: @tag)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:tag_id], "has already been taken"
  end
end
