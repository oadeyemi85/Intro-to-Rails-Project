class ParksController < ApplicationController
  def index
    @regions = Region.order(:name)
    @region_id = params[:region_id].presence
    parks = Park.includes(:region, :trails).order(:name)
    parks = parks.where(region_id: @region_id) if @region_id
    @parks = parks
    @map_markers = map_markers(@parks)
  end

  def show
    @park = Park.includes(:region, trails: %i[tags activities]).find(params[:id])
    @map_markers = map_markers([ @park ])
  end

  private

  def map_markers(records)
    records.map do |record|
      { title: record.name, latitude: record.latitude.to_f, longitude: record.longitude.to_f, url: park_path(record) }
    end
  end
end
