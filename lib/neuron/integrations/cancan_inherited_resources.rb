require 'inherited_resources'
require 'cancan'

module InheritedResources
  module Actions
    # GET /resources/1/edit
    def edit(options={}, &block)
      authorize! authorization_action, resource
      respond_with(*(with_chain(resource) << options), &block)
    end
    alias :edit! :edit
  end

  module BaseHelpers
    protected

    def resource
      get_resource_ivar ||
        set_resource_ivar(end_of_association_chain.accessible_by(current_ability, authorization_action).send(method_for_find, params[:id])).tap do |resource|
          authorize!(authorization_action, resource)
        end
    end

    def build_resource
      get_resource_ivar || set_resource_ivar(end_of_association_chain.send(method_for_build)).tap do |resource|
        current_ability.attributes_for(authorization_action, resource_class).each do |attribute, value|
          resource.send("#{attribute}=", value) if attribute.is_a?(Symbol)
        end
        resource.attributes = resource_params
        authorize!(action_name, resource)
      end
    end

    def collection
      get_collection_ivar || begin
        authorize!(authorization_action, resource_class)
        set_collection_ivar(end_of_association_chain.accessible_by(current_ability, authorization_action).paginate(page: params[:page]))
      end
    end

    def create_resource(object)
      authorize!(authorization_action, object)
      object.save
    end

    def update_resource(object, attributes)
      authorize!(authorization_action, object)
      object.update_attributes(attributes)
    end

    def destroy_resource(object)
      authorize!(authorization_action, object)
      object.destroy
    end

    private

    def authorization_action
      @authorization_action ||= action_name.to_sym
    end
  end

  module BelongsToHelpers
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
