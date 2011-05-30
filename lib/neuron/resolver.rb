require 'neuron'
require 'action_view/template/resolver'

module Neuron
  class Resolver < ::ActionView::FileSystemResolver
    def initialize
      super(File.join(Neuron.path, 'app', 'views'))
    end

    def find_templates(name, prefix, partial, details)
      super(name, 'defaults', partial, details)
    end
  end
end
