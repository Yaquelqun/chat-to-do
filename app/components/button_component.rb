# frozen_string_literal: true

# See: spec/components/button_component_spec.rb
class ButtonComponent < ViewComponent::Base
  def initialize(text:, **options)
    @text = text
    @options = options
  end

  private

  attr_reader :text, :options

  def button_attributes
    {
      type: options.fetch(:type, "button")
    }.merge(options.except(:class, :type))
  end
end
