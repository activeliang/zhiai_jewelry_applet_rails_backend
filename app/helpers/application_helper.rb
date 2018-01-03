module ApplicationHelper
  def render_hide_status(item)
    if item
      content_tag :span, '', class: "fa fa-lock", style: "color: #D50000; font-size: 22px;"
    else
      content_tag :span, '', class: "fa fa-unlock", style: "color: #2dbe60; font-size: 22px;"
    end
  end

  def render_status_display(item)
    if item
      content_tag :span, '', class: "fa fa-check-square-o", style: "color: #2dbe60; font-size: 22px;"
    else
      content_tag :span, '', class: "fa fa-times-circle-o", style: "color: #D50000; font-size: 22px;"
    end
  end


  def show_qr_code(link)
    qr = RQRCode::QRCode.new(link, :size => 9, :level => :m )

  end
end
