# See: spec/components/<%= file_name %>_component_spec.rb
class <%= component_class_name %> < ViewComponent::Base
  def initialize(**options)
    @options = options
  end

  private

  attr_reader :options
end