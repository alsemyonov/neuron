require 'neuron'
require 'cancan'
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

      module ClassMethods
        def authorize_resources(options = {})
          include Neuron::Authorization::Controller::ControllerExtension

          before_filter :authorize_resource
          has_scope(:authorize, type: :boolean, default: true) do |controller, scope|
            scope.accessible_by(controller.current_ability, controller.send(:authorization_action))
          end
        end
      end

      def access_denied(exception = nil)
        if user_signed_in?
          redirect_to '/422.html'
        else
          redirect_to new_user_session_path, alert: I18n.t('devise.failure.unauthenticated')
        end
      end

      module ControllerExtension
        protected

        def authorization_action
          @authorization_action ||= action_name.to_sym
        end

        def authorization_resource
          @authorization_resource ||= case authorization_action
                                      when :index
                                        resource_class
                                      when :new, :create
                                        build_resource
                                      else
                                        resource
                                      end
        end

        def authorize_resource
          authorize!(authorization_action, authorization_resource)
        end

        def build_resource
          get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build)).tap do |resource|
            current_ability.attributes_for(authorization_action, resource_class).each do |attribute, value|
              resource.send("#{attribute}=", value) if attribute.is_a?(Symbol)
            end
            resource.write_attributes(*resource_params)
          end
        end

        private

        # Evaluate the parent given. This is used to nest parents in the
        # association chain.
        def evaluate_parent(parent_symbol, parent_config, chain = nil) #:nodoc:
          instantiated_object = instance_variable_get("@#{parent_config[:instance_name]}")
          return instantiated_object if instantiated_object

          parent = if chain
                     chain.send(parent_config[:collection_name])
                   else
                     parent_config[:parent_class]
                   end.accessible_by(current_ability, :read)

          parent = parent.send(parent_config[:finder], params[parent_config[:param]])

          instance_variable_set("@#{parent_config[:instance_name]}", parent)
        end
      end
    end

    module View
    end
  end
end
