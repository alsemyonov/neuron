require 'neuron'
require 'active_support/concern'

module Neuron
  module Controller
    extend ActiveSupport::Concern

    def self.setup!
      if defined?(::ActionController)
        ActionController::Base.send(:include, Neuron::Controller)
        if defined?(::InheritedResources)
          ActionController::Base.send(:include, Neuron::Resources::Controller)
          require 'neuron/integrations/cancan_inherited_resources' if defined?(::CanCan)
        end
        ActionController::Base.send(:include, Neuron::Authorization::Controller) if defined?(::CanCan)
      end
    end

    module ClassMethods
      def append_neuron_view_path_resolver
        append_view_path Neuron::Resolver.new
      end
    end
  end
end
