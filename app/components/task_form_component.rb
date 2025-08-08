# frozen_string_literal: true

# See: spec/components/task_form_component_spec.rb
class TaskFormComponent < ViewComponent::Base
  def initialize(current_user:)
    @current_user = current_user
  end

  private

  attr_reader :current_user

  def form_attributes
    {
      action: "/tasks",
      method: "post",
      data: {
        controller: "task-form",
        action: "submit->task-form#submit"
      }
    }
  end

  def available_users
    User.where.not(id: current_user.id).order(:pseudo)
  end
end
