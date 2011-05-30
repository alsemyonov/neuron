require 'neuron'
require 'active_support/concern'

module Neuron
  module Authorization
    module Controller
      extend ActiveSupport::Concern

      included do
        rescue_from CanCan::AccessDenied do |exception|
          access_denied(exception)
        end
      end

      def access_denied(exception = nil)
        redirect_to '/422.html'
      end
    end

    module View
    end
  end
end
