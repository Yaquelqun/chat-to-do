# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task, title: "Test Task", description: "Test Description") }
  let(:creator) { create(:user) }
  let(:assignee) { create(:user) }

  before do
    create(:task_user, user: creator, task: task, role: TaskUser::CREATOR)
    create(:task_user, user: assignee, task: task, role: TaskUser::ASSIGNEE)
  end

  describe "GET /tasks/:id" do
    context "when user is logged in and involved in the task" do
      before do
        # Simulate logged in user
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(creator)
      end

      it "returns a successful response" do
        get task_path(task)
        
        expect(response).to be_successful
        expect(response.body).to include("Test Task")
        expect(response.body).to include("Test Description")
      end

      it "shows creator information" do
        get task_path(task)
        
        expect(response.body).to include(creator.pseudo)
      end

      it "shows assignee information" do
        get task_path(task)
        
        expect(response.body).to include(assignee.pseudo)
      end
    end

    context "when user is not involved in the task" do
      let(:unauthorized_user) { create(:user) }

      before do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(unauthorized_user)
      end

      it "redirects to dashboard with not found message" do
        get task_path(task)
        expect(response).to redirect_to(dashboard_path)
        follow_redirect!
        expect(response.body).to include("Task not found")
      end
    end

    context "when user is not logged in" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(false)
      end

      it "redirects to login page" do
        get task_path(task)
        
        expect(response).to redirect_to(login_path)
      end
    end
  end
end