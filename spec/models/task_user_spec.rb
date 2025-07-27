# Tests for TaskUser model
# Corresponding implementation: app/models/task_user.rb

require 'rails_helper'

RSpec.describe TaskUser, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      task_user = build(:task_user)
      expect(task_user).to be_valid
    end

    it "validates role is in allowed values" do
      task_user = build(:task_user, role: "invalid_role")
      expect(task_user).not_to be_valid
      expect(task_user.errors[:role]).to include("is not included in the list")
    end

    it "allows valid roles" do
      TaskUser::ROLES.each do |role|
        task_user = build(:task_user, role: role)
        expect(task_user).to be_valid
      end
    end
  end

  describe "associations" do
    it "belongs to user" do
      association = TaskUser.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to task" do
      association = TaskUser.reflect_on_association(:task)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "constants" do
    it "defines correct role constants" do
      expect(TaskUser::CREATOR).to eq("creator")
      expect(TaskUser::ASSIGNEE).to eq("assignee")
      expect(TaskUser::ROLES).to eq([ "creator", "assignee" ])
    end
  end
end
