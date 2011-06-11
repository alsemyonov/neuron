require 'neuron'
require 'show_for'

module Neuron
  module ShowFor
    extend ActiveSupport::Autoload

    autoload :Helper

    def self.setup!
      # Reconfigure ShowFor
      ShowFor.wrapper_tag = :dl
      ShowFor.label_tag = :dt
      ShowFor.content_tag = :dd
      ShowFor.separator = ''

      Helper # loads improved ShowFor helper
    end
  end
end
