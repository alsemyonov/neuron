require 'neuron/version'

module Neuron
  autoload :Application,  'neuron/application'
  autoload :Controller,   'neuron/controller'
  autoload :Navigation,   'neuron/navigation'
  autoload :Resolver,     'neuron/resolver'
  autoload :View,         'neuron/view'

  def self.enable!
    if defined?(ActionView)
      ActionView::Base.send :include, Neuron::View
      ActionView::Base.send :include, Neuron::Navigation::View
    end
    if defined?(ActionController)
      ActionController::Base.send :include, Neuron::Controller
    end
  end
end

Neuron.enable!  if defined?(Rails)
