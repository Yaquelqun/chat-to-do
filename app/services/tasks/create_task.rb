# frozen_string_literal: true

module Tasks
  # See: spec/services/tasks/create_task_spec.rb
  class CreateTask
  extend ApplicationService

    def initialize(params)
      @creator = params[:creator]
      @title = params[:title]
      @description = params[:description]
      @assignee_ids = Array(params[:assignee_ids]).compact
    end

    def call
      return ServiceResult.new(errors: [ "Creator is required" ]) unless creator

      ActiveRecord::Base.transaction do
        task = create_task
        return ServiceResult.new(errors: task.errors.full_messages) unless task.valid?

        create_creator_link(task)
        create_assignee_links(task)

        ServiceResult.new(result: task)
      end
    rescue StandardError => e
      ServiceResult.new(errors: [ e.message ])
    end

    private

    attr_reader :creator, :title, :description, :assignee_ids

    def create_task
      Task.create(
        title: title,
        description: description,
        state: Task::TODO
      )
    end

    def create_creator_link(task)
      TaskUser.create!(
        task: task,
        user: creator,
        role: TaskUser::CREATOR
      )
    end

    def create_assignee_links(task)
      return if assignee_ids.empty?

      assignees = User.where(id: assignee_ids)

      if assignees.count != assignee_ids.count
        raise StandardError, "Some assignees could not be found"
      end

      assignees.each do |assignee|
        TaskUser.create!(
          task: task,
          user: assignee,
          role: TaskUser::ASSIGNEE
        )
      end
    end
  end
end
