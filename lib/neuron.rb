require 'neuron/version'

module Neuron
  autoload :Application,    'neuron/application'
  autoload :Authorization,  'neuron/authorization'
  autoload :Navigation,     'neuron/navigation'
  autoload :Railtie,        'neuron/railtie'
  autoload :Resolver,       'neuron/resolver'
  autoload :Resources,      'neuron/resources'
  autoload :ShowFor,        'neuron/show_for'

  def self.setup!
    Neuron::Controller.setup!
    Neuron::View.setup!
  end

  def self.path
    File.expand_path('../..', __FILE__)
  end
end

require 'neuron/railtie' if defined?(Rails)
