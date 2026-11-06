class TrailsController < ApplicationController
  PER_PAGE = 12

  def index
    @query = params[:q].to_s.strip
    @region_id = params[:region_id].presence
    @tag_id = params[:tag_id].presence
    @regions = Region.order(:name)
    @tags = Tag.order(:name)

    trails = Trail.includes(:tags, :activities, park: :region).order(:name)
    unless @query.empty?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(@query)}%"
      trails = trails.joins(:park).where(
        "trails.name LIKE :pattern OR trails.description LIKE :pattern OR parks.name LIKE :pattern",
        pattern: pattern
      )
    end
    trails = trails.joins(park: :region).where(regions: { id: @region_id }) if @region_id
    trails = trails.where(id: TrailTag.where(tag_id: @tag_id).select(:trail_id)) if @tag_id

    @total_count = trails.distinct.count(:id)
    @total_pages = [ (@total_count.to_f / PER_PAGE).ceil, 1 ].max
    @page = [ [ params[:page].to_i, 1 ].max, @total_pages ].min
    @trails = trails.distinct.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
    @map_markers = map_markers(@trails)
  end

  def show
    @trail = Trail.includes(:tags, :activities, park: :region).find(params[:id])
    @map_markers = map_markers([ @trail ])
  end

  private

  def map_markers(records)
    records.map do |trail|
      { title: trail.name, latitude: trail.latitude.to_f, longitude: trail.longitude.to_f, url: trail_path(trail) }
    end
  end
end
