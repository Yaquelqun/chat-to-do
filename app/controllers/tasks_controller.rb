# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :require_login

  def create
    result = Tasks::CreateTask.call(
      creator: current_user,
      title: task_params[:title],
      description: task_params[:description],
      assignee_ids: task_params[:assignee_ids]
    )

    respond_to do |format|
      if result.success?
        format.json do
          render json: {
            status: "success",
            task: task_json(result.task)
          }, status: :created
        end
        format.html { redirect_to dashboard_path, notice: "Task created successfully!" }
      else
        format.json do
          render json: {
            status: "error",
            errors: result.errors
          }, status: :unprocessable_entity
        end
        format.html do
          flash[:alert] = result.errors.join(", ")
          redirect_to dashboard_path
        end
      end
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, assignee_ids: [])
  end

  def task_json(task)
    {
      id: task.id,
      title: task.title,
      description: task.description,
      state: task.state,
      created_at: task.created_at,
      updated_at: task.updated_at
    }
  end

  def require_login
    return if logged_in?

    respond_to do |format|
      format.json do
        render json: {
          status: "error",
          message: "Authentication required"
        }, status: :unauthorized
      end
      format.html { redirect_to login_path, alert: "Please log in to continue" }
    end
  end
end
