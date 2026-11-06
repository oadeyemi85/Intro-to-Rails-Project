require "test_helper"

class TrailNavigationTest < ActionDispatch::IntegrationTest
  setup do
    @region = Region.create!(
      name: "North Bay",
      province: "Ontario",
      country: "Canada",
      source_name: "Test gazetteer",
      latitude: 46.3,
      longitude: -79.4
    )
    @park = Park.create!(
      region: @region,
      name: "Pine Park",
      park_type: "Provincial park",
      description: "A park for exploring.",
      source_name: "Test park data",
      latitude: 46.3,
      longitude: -79.4
    )
    @trail = Trail.create!(
      park: @park,
      name: "Maple Loop",
      description: "A peaceful forest route.",
      difficulty: "Easy",
      surface: "Dirt",
      distance_km: 2.5,
      elevation_gain_m: 25,
      source_name: "Test trail data",
      latitude: 46.3,
      longitude: -79.4
    )
    @tag = Tag.create!(name: "Waterfall", description: "Routes beside falling water.")
    @trail.tags << @tag
    @activity = Activity.create!(name: "Hiking", description: "Walking outdoors.")
    @trail.activities << @activity
  end

  test "trail collection supports search and hierarchical filters" do
    get trails_path, params: { q: "Maple", region_id: @region.id, tag_id: @tag.id }

    assert_response :success
    assert_select "h3", text: "Maple Loop"
    assert_select ".atlas-map"
  end

  test "trail detail links back through its park and region" do
    get trail_path(@trail)

    assert_response :success
    assert_select "h1", text: "Maple Loop"
    assert_select "a[href=?]", park_path(@park), text: "Pine Park"
    assert_select "a[href=?]", region_path(@region), text: "North Bay"
    assert_select "a[href=?]", tag_path(@tag), text: "Waterfall"
    assert_select "a[href=?]", activity_path(@activity), text: "Hiking"
  end

  test "about page explains sources and shared navigation is present" do
    get about_path

    assert_response :success
    assert_select "nav[aria-label='Main navigation'] a", minimum: 4
    assert_select "h1", text: "A little more about the atlas"
    assert_includes response.body, "Faker"
  end
end
