class SsItem < ApplicationRecord

  belongs_to :service, class_name: SsService
  enum status: [:init , :complete]


  def expired?
    if self.draw_date.present? && self.draw_date < Time.now - 600
      true
    else
      false
    end
  end

  def android_code
    qr_code = "ss://" + (Base64.strict_encode64("rc4-md5:#{self.password}")).to_s + "@" + self.domain + ":" + self.port.to_s + "/?OTA=false"
  end

  def shadow_qr_code
    qr_code = "ss://" + (Base64.strict_encode64("rc4-md5:#{self.password}")).to_s + "@" + self.domain + ":" + self.port.to_s + "/?OTA=false"
    qr_code = (qr_code + '#' + URI.encode(self.wechat)) if self.wechat.present?
    qr_code = RQRCode::QRCode.new(qr_code.to_s, :size => 9, :level => :m)
  end

  def wingy_qr_code
    qr_code = "ss://" + (Base64.strict_encode64("rc4-md5:#{self.password}@#{self.domain}:#{self.port}")).to_s + "?rule=general"
    qr_code = (qr_code + '#' + URI.encode(self.wechat)) if self.wechat.present?
    qr_code = RQRCode::QRCode.new(qr_code.to_s, :size => 9, :level => :m)
  end
end
