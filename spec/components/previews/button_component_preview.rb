# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview
  def default
    render(ButtonComponent.new(text: "Click me"))
  end

  def primary
    render(ButtonComponent.new(text: "Primary Button", variant: :primary))
  end

  def secondary
    render(ButtonComponent.new(text: "Secondary Button", variant: :secondary))
  end

  def small
    render(ButtonComponent.new(text: "Small Button", size: :small))
  end

  def large
    render(ButtonComponent.new(text: "Large Button", size: :large))
  end
end
