require 'neuron'
require 'active_support/hash_with_indifferent_access'

module Neuron
  module Application
    class Base
      include Singleton

      def initialize
        @meta = {}
      end

      def meta
        @meta[I18n.locale] ||= I18n.t('application.meta').with_indifferent_access
      end

      def title
        meta[:title]
      end

      def keywords
        meta[:keywords]
      end

      def description
        meta[:description]
      end
    end
  end
end
