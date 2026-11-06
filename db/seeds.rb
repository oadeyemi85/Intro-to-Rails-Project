require "csv"
require "faker"

Faker::Config.random = Random.new(2026)

ActiveRecord::Base.transaction do
  TrailActivity.delete_all
  TrailTag.delete_all
  Trail.delete_all
  Activity.delete_all
  Tag.delete_all
  Park.delete_all
  Region.delete_all

  CSV.foreach(Rails.root.join("db/data/regions.csv"), headers: true, encoding: "bom|utf-8") do |row|
    Region.create!(
      name: row.fetch("name"),
      latitude: row.fetch("latitude"),
      longitude: row.fetch("longitude"),
      province: "Ontario",
      country: "Canada",
      source_name: "GeoNames geographical names database"
    )
  end

  CSV.foreach(Rails.root.join("db/data/parks.csv"), headers: true, encoding: "bom|utf-8") do |row|
    region = Region.find_by!(name: row.fetch("region"))
    Park.create!(
      region: region,
      name: row.fetch("park"),
      park_type: row.fetch("type"),
      latitude: row.fetch("latitude"),
      longitude: row.fetch("longitude"),
      website_url: row.fetch("website"),
      source_name: row.fetch("source_name"),
      description: "#{row.fetch('park')} is a place to explore Ontario's natural and cultural landscapes. Check the linked official site for current visitor information and trail conditions."
    )
  end

  tag_descriptions = {
    "Waterfall" => "Routes with a waterfall or cascade along the way.",
    "Lookout" => "Scenic viewpoints and rewarding overlooks.",
    "Forest" => "Shaded routes through woodland.",
    "Waterfront" => "Paths beside a lake, river, or shoreline.",
    "Wildlife" => "Good places to quietly observe local wildlife.",
    "Boardwalk" => "Routes with boardwalk sections over sensitive ground.",
    "Family friendly" => "Shorter routes suitable for a relaxed outing.",
    "Wildflowers" => "Seasonal blooms and diverse plant life."
  }
  tags = tag_descriptions.map { |name, description| Tag.create!(name: name, description: description) }

  activity_descriptions = {
    "Hiking" => "Explore on foot, from a quick leg-stretcher to a full-day route.",
    "Birdwatching" => "Take time to spot and listen for birds.",
    "Cycling" => "Enjoy a route that is suitable for riding a bicycle.",
    "Photography" => "Find landscapes, plants, and details worth capturing.",
    "Snowshoeing" => "Explore snowy routes in the winter season.",
    "Nature study" => "Notice local habitats, plants, and changing seasons."
  }
  activities = activity_descriptions.map { |name, description| Activity.create!(name: name, description: description) }

  Park.order(:id).each do |park|
    18.times do |index|
      trail = park.trails.create!(
        name: "#{park.name} Nature Loop %02d" % (index + 1),
        description: Faker::Lorem.paragraph(sentence_count: 3),
        difficulty: Trail::DIFFICULTIES[index % Trail::DIFFICULTIES.length],
        surface: %w[Dirt Gravel Boardwalk Rock].fetch(index % 4),
        distance_km: (((index % 12) + 1) * 0.65).round(2),
        elevation_gain_m: (index * 13) % 420,
        latitude: (park.latitude + (index % 5) * 0.004).round(6),
        longitude: (park.longitude - (index % 7) * 0.004).round(6),
        source_name: "Faker-generated demonstration trail catalog"
      )
      trail.tags << tags[index % tags.length]
      trail.tags << tags[(index + 3) % tags.length]
      trail.activities << activities[index % activities.length]
      trail.activities << activities[(index + 2) % activities.length]
    end
  end
end

raise "Expected at least 200 imported records" if Region.count + Park.count + Trail.count + Tag.count + Activity.count + TrailTag.count + TrailActivity.count < 200
raise "Expected at least 200 demonstration trails" if Trail.count < 200

puts "Trail Atlas seed complete:"
puts "  #{Region.count} regions, #{Park.count} parks, #{Trail.count} trails"
puts "  #{Tag.count} tags, #{Activity.count} activities"
puts "  #{TrailTag.count} trail tags, #{TrailActivity.count} trail activities"
