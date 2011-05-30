require 'neuron'
require 'rails'

module Neuron
  class Railtie < Rails::Engine
    config.to_prepare do
      Neuron.setup!
    end
  end
end
