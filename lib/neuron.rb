require 'neuron/version'

module Neuron
  autoload :Application,    'neuron/application'
  autoload :Authorization,  'neuron/authorization'
  autoload :Controller,     'neuron/controller'
  autoload :Navigation,     'neuron/navigation'
  autoload :Resolver,       'neuron/resolver'
  autoload :Resources,      'neuron/resources'
  autoload :Railtie,        'neuron/rails'
  autoload :View,           'neuron/view'

  def self.setup!
    if defined?(ActionView)
      ActionView::Base.send :include, Neuron::View
      ActionView::Base.send :include, Neuron::Navigation::View
    end
    if defined?(ActionController)
      ActionController::Base.send :include, Neuron::Controller
    end
    if defined?(InheritedResources)
      ActionController::Base.send :include, Neuron::Resources::Controller
      ActionView::Base.send :include, Neuron::Resources::View
      if defined?(CanCan)
        require 'neuron/integrations/cancan_inherited_resources'
      end
    end
    if defined?(CanCan)
      ActionController::Base.send :include, Neuron::Authorization::Controller
      ActionView::Base.send :include, Neuron::Authorization::View
    end
  end

  def self.path
    File.expand_path('../..', __FILE__)
  end
end

require 'neuron/rails' if defined?(Rails)
