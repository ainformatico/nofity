class Link < ActiveRecord::Base
  include UserItemizable

  before_save :ensure_raw

  def ensure_raw
    self.raw_url = url
  end

  belongs_to :note, touch: true

  validates :url, presence: true
  validates :user, presence: true
end
