class RegionsController < ApplicationController
  def index
    @regions = Region.includes(:parks).order(:name)
    @map_markers = map_markers(@regions)
  end

  def show
    @region = Region.includes(parks: { trails: %i[tags activities] }).find(params[:id])
    @parks = @region.parks.order(:name)
    @map_markers = map_markers(@parks)
  end

  private

  def map_markers(records)
    records.map do |record|
      { title: record.name, latitude: record.latitude.to_f, longitude: record.longitude.to_f, url: polymorphic_path(record) }
    end
  end
end
