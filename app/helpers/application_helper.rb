module ApplicationHelper
  def page_heading(title, subtitle: nil)
    content_for :title, "#{title} | Trail Atlas"
    content_for :page_heading, title
    content_for :page_subtitle, subtitle if subtitle
  end
end
