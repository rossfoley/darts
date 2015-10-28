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

module Darts
  class Application < Rails::Application
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Set Sass as the Default Styling file type
    config.sass.preferred_syntax = :sass

    config.generators do |g|
      g.assets false
      g.helper false
      g.fixture false
      g.javascripts false
      g.stylesheets false
      g.view_specs false
      g.routing_specs false
      g.request_specs false
    end
  end
end
