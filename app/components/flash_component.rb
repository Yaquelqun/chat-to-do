# frozen_string_literal: true

# See: spec/components/flash_component_spec.rb
class FlashComponent < ViewComponent::Base
  def initialize(type:, message:)
    @type = type
    @message = message
  end

  private

  attr_reader :type, :message

  def flash_css_class
    "flash-#{type}"
  end

  def controller_data_attributes
    {
      data: {
        controller: "flash",
        flash_auto_dismiss_value: 5000
      }
    }
  end
end
