class <%= component_class_name %>Preview < ViewComponent::Preview
  def default
    render(<%= component_class_name %>.new)
  end
end