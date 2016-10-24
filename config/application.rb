require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load Env Variables
unless Rails.env.production? or Rails.env.staging?
  require 'dotenv'
  Dotenv.load
end

module PlataformaBrasil
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Brasilia'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :'pt-BR'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.test_framework :rspec
      g.factory_girl dir: 'spec/factories'
      g.helper false
      g.assets false
    end

    config.autoload_paths += Dir[Rails.root.join('lib', '**/')]

    Rails.application.config.assets.precompile += %w( navbar-sticky.js home-parallax.js blur-fade.js dotdotdot-discussions.js dotdotdot-comments.js base_header_scroll_to.js tinymce.css admin/highlights.js )

    # IMPORT FONTS
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.precompile += %w( .eot .woff .ttf .svg)

    # CONFIG MANDRILL
    config.action_mailer.smtp_settings = {
      address: ENV["SMTP_ADDRESS"],
      authentication: :plain,
      domain: ENV["SMTP_DOMAIN"],
      enable_starttls_auto: true,
      password: ENV["SMTP_PASSWORD"],
      port: ENV["SMTP_PORT"],
      user_name: ENV["SMTP_USERNAME"]
    }

    config.action_mailer.default_url_options = { host: ENV["SMTP_DOMAIN"] }

    config.cache_store = :file_store, "#{Rails.root}/temp"
  end
end
