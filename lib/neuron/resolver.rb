require 'neuron'
require 'action_view/template/resolver'

module Neuron
  class Resolver < ::ActionView::FileSystemResolver
    def initialize
      super('app/views/neuron')
    end

    def find_templates(name, prefix, partial, details)
      super(name, 'defaults', partial, details)
    end
  end
end
