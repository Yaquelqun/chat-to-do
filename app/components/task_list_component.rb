# frozen_string_literal: true

# See: spec/components/task_list_component_spec.rb
class TaskListComponent < ViewComponent::Base
  def initialize(title:, tasks:)
    @title = title
    @tasks = tasks
  end

  private

  attr_reader :title, :tasks

  def has_tasks?
    tasks.any?
  end

  def truncated_title(task, limit = 25)
    task.title.length > limit ? "#{task.title.truncate(limit)}..." : task.title
  end

  def task_state_class(task)
    "task-state-#{task.state.gsub(' ', '-')}"
  end
end