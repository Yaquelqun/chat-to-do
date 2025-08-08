# frozen_string_literal: true

require "rails_helper"

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:assignee1) { create(:user) }
  let(:assignee2) { create(:user) }

  before do
    # Mock the logged_in? and current_user methods from ApplicationController
    allow(controller).to receive(:logged_in?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          task: {
            title: "New Task",
            description: "Task description",
            assignee_ids: [ assignee1.id, assignee2.id ]
          },
          format: :json
        }
      end

      it "creates a new task using the service" do
        expect(Tasks::CreateTask).to receive(:call).with(
          creator: user,
          title: "New Task",
          description: "Task description",
          assignee_ids: [ assignee1.id.to_s, assignee2.id.to_s ]
        ).and_call_original

        post :create, params: valid_params

        expect(response).to have_http_status(:created)
      end

      it "returns created task in JSON format" do
        post :create, params: valid_params

        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("success")
        expect(json_response["task"]["title"]).to eq("New Task")
        expect(json_response["task"]["state"]).to eq("todo")
      end

      it "increases task count" do
        expect do
          post :create, params: valid_params
        end.to change(Task, :count).by(1)
      end
    end

    context "with minimal valid parameters" do
      let(:minimal_params) do
        {
          task: {
            title: "Simple Task"
          },
          format: :json
        }
      end

      it "creates task without description or assignees" do
        post :create, params: minimal_params

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["task"]["title"]).to eq("Simple Task")
        expect(json_response["task"]["description"]).to be_nil
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          task: {
            description: "Task without title"
          },
          format: :json
        }
      end

      it "returns unprocessable entity status" do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages in JSON format" do
        post :create, params: invalid_params

        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["errors"]).to include("Title can't be blank")
      end

      it "does not create a task" do
        expect do
          post :create, params: invalid_params
        end.not_to change(Task, :count)
      end
    end

    context "with invalid assignee ids" do
      let(:params_with_invalid_assignees) do
        {
          task: {
            title: "Task with invalid assignees",
            assignee_ids: [ 999, 1000 ]
          },
          format: :json
        }
      end

      it "returns unprocessable entity status" do
        post :create, params: params_with_invalid_assignees

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Some assignees could not be found")
      end
    end

    context "when user is not logged in" do
      before do
        allow(controller).to receive(:logged_in?).and_return(false)
      end

      let(:valid_params) do
        {
          task: {
            title: "New Task"
          },
          format: :json
        }
      end

      it "returns unauthorized status" do
        post :create, params: valid_params

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        post :create, params: valid_params

        json_response = JSON.parse(response.body)
        expect(json_response["status"]).to eq("error")
        expect(json_response["message"]).to eq("Authentication required")
      end
    end

    context "handling non-JSON requests" do
      let(:html_params) do
        {
          task: {
            title: "New Task"
          }
        }
      end

      it "redirects HTML requests" do
        post :create, params: html_params

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(dashboard_path)
      end
    end
  end
end
