# frozen_string_literal: true

# See: spec/components/sidebar_component_spec.rb
class SidebarComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private

  attr_reader :user

  def application_name
    "ChatToDo"
  end
end
