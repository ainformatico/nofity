class Note < ActiveRecord::Base
  include UserItemizable
  include Idsec

  has_many :note_categories
  has_many :categories, through: :note_categories

  has_one :link

  validates :user, presence: true

  scope :all_public, -> { where(public: true) }

  after_save :update_sitemap

  def self.private_or_public(user, idsec = false)
    for_user(user, idsec) || includes(:categories).find_by(idsec: idsec, public: true)
  end

  def self.for_user(user, idsec = false)
    if idsec
      user.notes.includes(:categories).find_by(idsec: idsec)
    else
      user.notes.includes(:categories).reverse
    end
  end

  def self.public(idsec)
    find_by(idsec: idsec, public: true)
  end

  def self.all_public_desc
    all_public.order(id: :desc)
  end

  # fix for strong_params in order to
  # recognize categories
  def self.attribute_names
    data = super
    data.dup << 'categories'
  end

  def update_sitemap
    ::GenerateSitemap.perform_async
  end
end
