require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module DnFresherHaikhanhEcomerces
  class Application < Rails::Application
    config.load_defaults 6.1
    config.load_defaults 6.1
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.i18n.available_locales = [:en, :vi]
    config.i18n.default_locale = :en
    config.time_zone = "Hanoi"
    config.active_record.default_timezone = :local
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
