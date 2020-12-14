require_relative 'boot'

require 'rails/all'
require 'timers'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module AnnouncebotFinal
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0



    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #

    config.x.start_time = Time.now.to_i

    config.x.toggle = true

    config.x.hasSpoken = false

    config.x.hasnt_posted_even_once = true

  end
end
