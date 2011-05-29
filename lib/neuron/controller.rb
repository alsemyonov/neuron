require 'neuron'
require 'active_support/concern'

module Neuron
  module Controller
    extend ActiveSupport::Concern

    module ClassMethods
      def append_neuron_view_path_resolver
        append_view_path Neuron::Resolver.new
      end
    end
  end
end
