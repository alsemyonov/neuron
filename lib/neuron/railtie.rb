require 'neuron'
require 'rails'
require 'rails/engine'

class Neuron::Railtie < Rails::Engine
  config.app_generators.stylesheets false

  config.to_prepare do
    Neuron.setup!
  end
end
