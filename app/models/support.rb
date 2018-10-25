class Support < ActiveRecord::Base
  validates :email, presence: true
  validates :content, presence: true
  validates_format_of :email, with: Devise.email_regexp
end
