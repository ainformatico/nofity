require 'securerandom'

module Idsec
  extend ActiveSupport::Concern

  included do
    after_create :assign_idsec
  end

  def assign_idsec
    idsec = SecureRandom.hex
    update_attribute(:idsec, idsec)
  end
end
