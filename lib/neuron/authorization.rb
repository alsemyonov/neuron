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

      if defined?(::Devise)
        def access_denied(exception = nil)
          if user_signed_in?
            redirect_to '/422.html'
          else
            redirect_to new_user_session_path, alert: I18n.t('devise.failure.unauthenticated')
          end
        end
      else
        def access_denied(exception = nil)
          redirect_to '/422.html'
        end
      end

    end

    module View
    end
  end
end
