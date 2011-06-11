require 'neuron'

module Neuron
  module Resources
    module Controller
      extend ActiveSupport::Concern

      module ClassMethods
        def resources(options = {})
          inherit_resources
          append_neuron_view_path_resolver
          if options[:orders] == true
            order_scopes
          elsif options[:orders]
            order_scopes(options[:orders])
          end
        end
        # Adds default ordering scopes for #index action
        # @param [Hash] options options hash
        # @option options [Array, Symbol, String] :ascending default ascending scopes
        # @option options [Array, Symbol, String] :descending default descending scopes
        def order_scopes(options = {})
          with_options only: :index, type: :array do |index|
            index.has_scope(:ascending) { |controller, scope, values| values.any? ?  scope.asc(*values) : scope }
            index.has_scope(:descending) { |controller, scope, values| values.any? ?  scope.desc(*values) : scope }
          end
          prepend_before_filter :set_default_order
          define_method(:set_default_order) do
            unless params[:ascending] || params[:descending]
              params[:ascending] = options[:ascending]    if options[:ascending]
              params[:descending] = options[:descending]  if options[:descending]
            end
            params[:ascending] = Array(params[:ascending])
            params[:descending] = Array(params[:descending])
          end
        end
      end
    end

    module View
      # Creates a link that alternates between acending and descending
      # @param [Hash] options options hash
      # @param [Hash] html_options html options hash
      # @option options [Symbol, String] :by the name of the columnt to sort by
      # @option options [String] :as the text used in link, defaults to human_method_name of :by
      # @option options [String] :url url options when order link does not correspond to current collection_path
      def order(options = {}, html_options = {})
        options[:class] ||= resource_class
        options[:by] = options[:by].to_sym
        options[:as] ||= human(options[:class], options[:by])
        html_options[:title] ||= human(options[:class], options[:by])
        asc_orders  = Array(params[:ascending]).map(&:to_sym)
        desc_orders = Array(params[:descending]).map(&:to_sym)
        ascending = asc_orders.include?(options[:by])
        selected  = ascending || desc_orders.include?(options[:by])
        new_scope = ascending ? :descending : :ascending
        url_options = {page: params[:page]}
        url_options[new_scope] = [options[:by]]

        if selected
          css_classes = html_options[:class] ? html_options[:class].split(/\s+/) : []
          if ascending # selected
            options[:as] = "&#9650;&nbsp;#{options[:as]}"
            css_classes << 'ascending'
          else # descending selected
            options[:as] = "&#9660;&nbsp;#{options[:as]}"
            css_classes << 'descending'
          end
          html_options[:class] = css_classes.join(' ')
        end
        url = options[:url] ? url_for(options[:url].merge(url_options)) : collection_path(url_options)

        link_to(options[:as].html_safe, url, html_options)
      end

      def collection_title(collection = nil, options = {})
        collection ||= self.collection
        tag           = options.delete(:tag)      { :h1 }
        new_link      = options.delete(:new_link) { link_to(t("#{controller_i18n_scope}.new", scope: :actions, default: [:new, 'New']), new_resource_path) }
        i18n_options  = options.delete(:i18n)     { {count: collection.count} }
        ''.html_safe.tap do |result|
          result << title(t("#{controller_i18n_scope}.#{view_name}.title",
                            options.merge(default: t("navigation.#{controller_i18n_scope}.#{action_name}", i18n_options))),
                          tag: tag)
          if new_link && can?(:create, resource_class) && controller.respond_to?(:create)
            result << new_link
          end
        end
      end

      def collection_list(collection = nil, collection_name = nil)
        collection      ||= self.collection
        collection_name ||= self.resource_collection_name
        if collection.respond_to?(:total_pages)
          start = 1 + (collection.current_page - 1) * collection.per_page
          pagination = will_paginate(collection)
        else
          start = 1
          pagination = ''
        end
        content_tag(:ol,
                    render(collection),
                    class: "b-list b-list_#{collection_name.to_s.gsub(/_/, '-')}",
                    start: start) << pagination
      end

      def collection_block(collection = nil, tag = :h1, &block)
        collection ||= self.collection
        content_tag(:article, class: 'b-collection') do
          ''.html_safe.tap do |result|
            result << content_tag(:header, collection_title(collection, tag: tag), class: 'b-collection__header')
            if block_given?
              result << capture(&block)
            else
              result << if collection.any?
                          collection_list(collection)
                        else
                          content_tag(:p, t(:no_entries,
                                            scope: [:resources, :collection, :no_entries],
                                            default: [controller_i18n_scope.to_sym, :all]))
                        end
            end
          end
        end
      end

      def resource_title(resource = nil)
        resource ||= self.resource
        action = action_name.to_sym
        ''.html_safe.tap do |result|
          result << title(nil,
                          resource: link_to(resource, canonical_path(resource)),
                          default:  resource.to_s)
          if (action == :show) && can?(:update, resource) && controller.respond_to?(:edit)
            result << content_tag(:sup,
              link_to(t(:edit,
                        object: resource,
                        scope: :actions,
                        default: [:"#{controller_i18n_scope}.edit", :edit, 'Edit']), edit_resource_path))
          end
          #if (action == :edit) && can?(:update, resource)
            #result << content_tag(:sup, link_to(t(:edit, :scope => "actions.#{controller_i18n_scope}"), edit_resource_path))
          #end
        end
      end
    end
  end
end
