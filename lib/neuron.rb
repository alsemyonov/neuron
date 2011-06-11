require 'neuron/version'

module Neuron
  autoload :Application,    'neuron/application'
  autoload :Authorization,  'neuron/authorization'
  autoload :Controller,     'neuron/controller'
  autoload :Navigation,     'neuron/navigation'
  autoload :Railtie,        'neuron/railtie'
  autoload :Resolver,       'neuron/resolver'
  autoload :Resources,      'neuron/resources'
  autoload :ShowFor,        'neuron/show_for'
  autoload :View,           'neuron/view'

  class << self
    def setup!
      Neuron::Controller.setup!
      Neuron::View.setup!
    end

    def path
      File.expand_path('../..', __FILE__)
    end
  end
end

require 'neuron/railtie' if defined?(Rails)
