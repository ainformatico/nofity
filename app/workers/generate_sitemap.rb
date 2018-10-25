require 'dynamic_sitemaps'

class GenerateSitemap
  include Sidekiq::Worker

  def perform
    DynamicSitemaps.generate_sitemap
  end
end
