# frozen_string_literal: true

# See: spec/components/collapsible_panel_component_spec.rb
class CollapsiblePanelComponent < ViewComponent::Base
  def initialize(title:, collapsed: true, id: nil)
    @title = title
    @collapsed = collapsed
    @id = id || generate_id
  end

  private

  attr_reader :title, :collapsed, :id

  def panel_attributes
    {
      id: id,
      class: panel_classes,
      data: {
        controller: "collapsible-panel"
      }
    }
  end

  def panel_classes
    classes = [ "collapsible-panel" ]
    classes << "collapsed" if collapsed
    classes.join(" ")
  end

  def header_attributes
    {
      class: "panel-header",
      data: {
        action: "click->collapsible-panel#toggle"
      },
      "aria-labelledby": title_id,
      "aria-expanded": (!collapsed).to_s
    }
  end

  def content_attributes
    {
      class: "panel-content panel-content-grid",
      data: {
        "collapsible-panel-target": "content"
      },
      "aria-hidden": collapsed.to_s
    }
  end

  def title_id
    "#{id}-title"
  end

  def generate_id
    "collapsible-panel-#{SecureRandom.hex(4)}"
  end
end
