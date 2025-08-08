# frozen_string_literal: true

# See: spec/components/modal_component_spec.rb
class ModalComponent < ViewComponent::Base
  def initialize(id:, title:)
    @id = id
    @title = title
  end

  private

  attr_reader :id, :title

  def modal_attributes
    {
      id: id,
      class: "modal",
      role: "dialog",
      "aria-labelledby": title_id,
      "aria-hidden": "true",
      data: {
        controller: "modal",
        action: "keydown.escape->modal#close"
      }
    }
  end

  def title_id
    "#{id}-title"
  end
end
