require 'neuron'
require 'active_support/concern'

module Neuron
  module Controller
    extend ActiveSupport::Concern

    def self.setup!
      if defined?(::ActionController)
        ActionController::Base.send(:include, Neuron::Controller)
        ActionController::Base.send(:include, Neuron::Resources::Controller)      if defined?(::InheritedResources)
        ActionController::Base.send(:include, Neuron::Authorization::Controller)  if defined?(::CanCan)
      end
    end
  end
end
