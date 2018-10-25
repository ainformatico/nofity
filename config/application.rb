require File.expand_path('boot', __dir__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

# do not check ssl certificates
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Nfy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.assets.enabled = true
    config.assets.version = '1.0'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.generators do |g|
      g.test_framework :rspec
      g.integration_tool :rspec
    end

    # static pages support
    config.assets.paths << Rails.root.join('app/assets/html')
    config.assets.register_mime_type('text/html', '.html')
    config.assets.precompile += %w[.html]

    # load lib/
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    config.dust.template_root = "#{Rails.root}/app/assets/javascripts/backbone/templates/"

    config.cache_store = :redis_store, {
      db: 0,
      namespace: 'nofity',
      url: ENV.fetch('REDIS_URL')
    }

    config.action_mailer.default_url_options = { host: 'nofity.com' }
    config.action_mailer.smtp_settings = {
      authentication: :plain,
      # this prevents an error with the local certificate
      enable_starttls_auto: false
    }
    config.action_mailer.delivery_method :smtp

    config.active_record.raise_in_transactional_callbacks = true
  end
end
