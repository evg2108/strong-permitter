require 'strong_permitter/version'
require 'strong_permitter/manager'
require 'strong_permitter/permission/base'

if defined? Rails
  module StrongPermitter
    class Railtie < ::Rails::Railtie
      initializer 'strong-permitter.autoload', :before => :set_autoload_paths do |app|
        app.config.autoload_paths += %W(#{Rails.root}/app/controllers/permissions)
      end
    end
  end
end
