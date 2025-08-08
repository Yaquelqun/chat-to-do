# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tasks::CreateTask, type: :service do
  let(:creator) { create(:user) }
  let(:assignee1) { create(:user) }
  let(:assignee2) { create(:user) }

  describe "#call" do
    context "with valid parameters" do
      let(:params) do
        {
          creator: creator,
          title: "New Task",
          description: "Task description",
          assignee_ids: [ assignee1.id, assignee2.id ]
        }
      end

      it "creates a task with todo state" do
        result = described_class.call(params)

        expect(result.success?).to be true
        expect(result.result).to be_persisted
        expect(result.result.title).to eq("New Task")
        expect(result.result.description).to eq("Task description")
        expect(result.result.state).to eq(Task::TODO)
      end

      it "links creator with creator role" do
        result = described_class.call(params)

        creator_link = result.result.task_users.find_by(user: creator)
        expect(creator_link).to be_present
        expect(creator_link.role).to eq(TaskUser::CREATOR)
      end

      it "links assignees with assignee role" do
        result = described_class.call(params)

        assignee_links = result.result.task_users.where(user: [ assignee1, assignee2 ])
        expect(assignee_links.count).to eq(2)
        assignee_links.each do |link|
          expect(link.role).to eq(TaskUser::ASSIGNEE)
        end
      end

      it "returns success result" do
        result = described_class.call(params)

        expect(result.success?).to be true
        expect(result.failure?).to be false
        expect(result.errors).to be_empty
      end
    end

    context "with minimal valid parameters" do
      let(:params) do
        {
          creator: creator,
          title: "Simple Task"
        }
      end

      it "creates task without description or assignees" do
        result = described_class.call(params)

        expect(result.success?).to be true
        expect(result.result.title).to eq("Simple Task")
        expect(result.result.description).to be_nil
        expect(result.result.state).to eq(Task::TODO)
        expect(result.result.task_users.count).to eq(1) # Only creator
      end
    end

    context "with invalid parameters" do
      context "missing title" do
        let(:params) do
          {
            creator: creator,
            description: "Task without title"
          }
        end

        it "returns failure result" do
          result = described_class.call(params)

          expect(result.failure?).to be true
          expect(result.success?).to be false
          expect(result.errors).to include("Title can't be blank")
          expect(result.result).to be_nil
        end
      end

      context "missing creator" do
        let(:params) do
          {
            title: "Task without creator"
          }
        end

        it "returns failure result" do
          result = described_class.call(params)

          expect(result.failure?).to be true
          expect(result.errors).to include("Creator is required")
        end
      end

      context "invalid assignee ids" do
        let(:params) do
          {
            creator: creator,
            title: "Task with invalid assignees",
            assignee_ids: [ 999, 1000 ] # Non-existent user IDs
          }
        end

        it "returns failure result" do
          result = described_class.call(params)

          expect(result.failure?).to be true
          expect(result.errors).to include("Some assignees could not be found")
        end
      end
    end

    context "database transaction rollback" do
      let(:params) do
        {
          creator: creator,
          title: "Task that will fail",
          assignee_ids: [ assignee1.id ]
        }
      end

      it "rolls back all changes when TaskUser creation fails" do
        # Mock TaskUser creation to fail
        allow(TaskUser).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)

        expect { described_class.call(params) }.not_to change(Task, :count)
      end
    end
  end
end
