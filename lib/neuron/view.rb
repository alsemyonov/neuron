require 'neuron'

module Neuron
  module View
    def self.setup!
      if defined?(::ActionView)
        ActionView::Base.send(:include, Neuron::View)
        ActionView::Base.send(:include, Neuron::Navigation::View)
        ActionView::Base.send(:include, Neuron::Resources::View)      if defined?(::InheritedResources)
        ActionView::Base.send(:include, Neuron::Authorization::View)  if defined?(::CanCan)
        ActionView::Base.send(:include, Neuron::ShowFor::Helper)      if defined?(::ShowFor)
      end
    end

    def block_modifiers(block, *modifiers)
      klasses = [block]
      if (options = modifiers.extract_options!).any?
        options.each do |modifier, needed|
          klasses << "#{block}_#{modifier}" if needed
        end
      end
      klasses += modifiers.collect { |modifier| "#{block}_#{modifier}" }
      {:class => klasses.join(' ')}
    end

    # Make body’s modifiers, based on controller_name and action_name
    def body_attributes
      controller_class = controller_i18n_scope.gsub(/[._]/, '-')
      block_modifiers("m-#{controller_class}", view_name).tap do |hash|
        hash[:class] << " m-action_#{view_name}"
      end
    end

    def html_attributes
      {:lang => I18n.locale}
    end

    def human(klass, attribute = nil)
      @human ||= {}
      @human[klass] ||= {}
      @human[klass][attribute] ||= attribute ? klass.human_attribute_name(attribute) : klass.name.human
    end

    # Build canonical url for given resource
    def canonical_url(resource, options = {})
      polymorphic_url(resource, options)
    end

    # Build canonical path for given resource
    def canonical_path(resource, options = {})
      canonical_url(resource, options.merge(routing_type: :path))
    end

    def canonical_link(resource = nil, options = {})
      href = case resource
             when Hash
               url_for(resource)
             when NilClass
               request.request_uri.split('?').first
             else
               canonical_url(resource, options)
             end
      href = "#{request.protocol}#{request.host_with_port}#{href}" unless href =~ /^\w+:\/\//
      tag(:link, rel: 'canonical', href: href)
    end

    def view_name
      {create: 'new', update: 'edit'}[action_name] || action_name
    end

    def controller_i18n_scope
      @controller_i18n_scope ||= controller.controller_path.gsub(%r{/}, '.')
    end

    def time(time, options = {})
      format        = options.delete(:format) { :short }
      title  = options.delete(:title) do
        title_format  = options.delete(:title_format) { :long }
        l(time, format: title_format)
      end
      content_tag(:time, l(time, format: format), options.merge(datetime: time.xmlschema, title: title))
    end

    def date(date, options = {})
      time(date.to_date)
    end
  end
end
