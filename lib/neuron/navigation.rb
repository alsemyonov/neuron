# encoding: utf-8
require 'neuron'

module Neuron
  # Navigational helpers: page and head titles
  module Navigation
    class Title
      attr_accessor :default_options
      attr_reader :view

      class << self
        def navigation_title(controller, action = :index, options = {})
          I18n.t("navigation.#{controller}.#{action}", options)
        end
      end

      def initialize(view, options = {})
        @view = view
        @navigation_title = nil
        @page_title = nil
        @head_title = nil
        @default_options = {title_separator: ' — '}.merge(options)
      end

      def page_title(title = nil, options = {})
        options = default_options.merge(options)
        options = options.merge(default: navigation_title(title, options))
        @page_title ||= title.to_s || view.t('.title', options)
      end

      def navigation_title(title = nil, options = {})
        options = {default: @page_title || view.view_name.humanize}.merge(default_options).merge(options)
        @navigation_title ||= title.to_s || self.class.navigation_title(view.controller_i18n_scope, view.view_name, options)
      end

      def head_title(title = nil, options = {})
        options = default_options.merge(options)
        @head_title ||= title.to_s || view.strip_tags([navigation_title, application.title].compact.join(options[:title_separator]))
      end

      protected

      def application
        @application ||= Neuron::Application::Base.instance
      end
    end

    module View
      # Title of the current page
      # @param [String, nil] title title to set
      # @param [Hash] options options to {I18n#translate} if building default title
      def page_title(title = nil, options = {})
        neuron_title.page_title(title, options).html_safe
      end

      def navigation_title(title = nil, options = {})
        neuron_title.navigation_title(title, options)
      end

      def head_title(title = nil, options = {})
        neuron_title.head_title(title, options)
      end

      def title(new_title = nil, options = {})
        tag = options.delete(:tag) { :h1 }
        content_tag(tag, page_title(new_title, options))
      end

      protected

      def neuron_title
        @neuron_title ||= Neuron::Navigation::Title.new(self)
      end
    end
  end
end
