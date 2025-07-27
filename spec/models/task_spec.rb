# Tests for Task model
# Corresponding implementation: app/models/task.rb

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      task = build(:task)
      expect(task).to be_valid
    end

    it "requires a title" do
      task = build(:task, title: nil)
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it "requires a state" do
      task = build(:task, state: nil)
      expect(task).not_to be_valid
      expect(task.errors[:state]).to include("can't be blank")
    end

    it "validates state is in allowed values" do
      task = build(:task, state: "invalid_state")
      expect(task).not_to be_valid
      expect(task.errors[:state]).to include("is not included in the list")
    end

    it "allows valid states" do
      Task::STATES.each do |state|
        task = build(:task, state: state)
        expect(task).to be_valid
      end
    end
  end

  describe "associations" do
    it "has many task_users" do
      association = Task.reflect_on_association(:task_users)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "has many users through task_users" do
      association = Task.reflect_on_association(:users)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:task_users)
    end
  end

  describe "constants" do
    it "defines correct state constants" do
      expect(Task::TODO).to eq("to do")
      expect(Task::ONGOING).to eq("ongoing")
      expect(Task::DONE).to eq("done")
      expect(Task::STATES).to eq([ "to do", "ongoing", "done" ])
    end
  end
end
