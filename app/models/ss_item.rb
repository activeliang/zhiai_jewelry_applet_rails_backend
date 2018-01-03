class SsItem < ApplicationRecord

  enum status: [:init , :complete]


  def expired?
    if self.draw_date.present? && self.draw_date < Time.now - 600
      true
    else
      false
    end
  end
end
