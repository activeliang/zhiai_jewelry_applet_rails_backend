module ApplicationHelper
  def render_hide_status(item)
    if item
      content_tag :span, '', class: "fa fa-lock", style: "color: #D50000; font-size: 22px;"
    else
      content_tag :span, '', class: "fa fa-unlock", style: "color: #2dbe60; font-size: 22px;"
    end
  end
end
