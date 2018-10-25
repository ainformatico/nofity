require 'securerandom'

module UserItemizable
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    default_scope -> { where(deleted: false) }
  end

  def remove
    update_attribute(:deleted, true)
  end
end
