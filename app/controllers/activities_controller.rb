class ActivitiesController < ApplicationController
  def index
    @activities = Activity.includes(:trails).order(:name)
  end

  def show
    @activity = Activity.includes(trails: { park: :region }).find(params[:id])
    @trails = @activity.trails.includes(:tags, :activities, park: :region).order(:name)
  end
end
