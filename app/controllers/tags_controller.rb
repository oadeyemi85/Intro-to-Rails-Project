class TagsController < ApplicationController
  def index
    @tags = Tag.includes(:trails).order(:name)
  end

  def show
    @tag = Tag.includes(trails: { park: :region }).find(params[:id])
    @trails = @tag.trails.includes(:tags, :activities, park: :region).order(:name)
  end
end
