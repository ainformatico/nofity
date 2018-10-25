class Category < ActiveRecord::Base
  include UserItemizable
  include Idsec

  has_many :note_categories
  has_many :notes, through: :note_categories

  validates :name, presence: true
  validates :user, presence: true

  def self.for_user(user, idsec = false)
    result = []
    result = if idsec
               user.categories.find_by(idsec: idsec)
             else
               user.categories.reverse
             end

    result
  end
end
