require 'neuron'
require 'neuron/controller'
require 'neuron/view'
require 'rails'
require 'rails/engine'

class Neuron::Railtie < Rails::Engine
  config.neuron = Neuron

  if config.respond_to?(:app_generators)
    config.app_generators.stylesheets false
  else
    config.generators.stylesheets false
  end

  config.to_prepare do
    Neuron.setup!
  end
end
