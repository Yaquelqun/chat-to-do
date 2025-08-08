# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskFormComponent, type: :component do
  let(:current_user) { create(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe "rendering" do
    it "renders a form for creating tasks" do
      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_css("form[action='/tasks']")
      expect(page).to have_css("form[method='post']")
      expect(page).to have_css("[data-controller='task-form']")
    end

    it "includes title field" do
      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_field("task[title]", type: "text")
      expect(page).to have_css("input[required]")
      expect(page).to have_css("label", text: "Title")
    end

    it "includes description field" do
      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_field("task[description]", type: "textarea")
      expect(page).to have_css("label", text: "Description")
    end

    it "includes assignee selection" do
      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_css("select[name='task[assignee_ids][]']")
      expect(page).to have_css("select[multiple]")
      expect(page).to have_css("label", text: "Assignees")
    end

    it "excludes current user from assignee options" do
      user1 = create(:user, pseudo: "User1")
      user2 = create(:user, pseudo: "User2")
      current_user = create(:user, pseudo: "CurrentUser")

      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_css("option", text: "User1")
      expect(page).to have_css("option", text: "User2")
      expect(page).not_to have_css("option", text: "CurrentUser")
    end

    it "includes submit button" do
      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_button("Create Task", type: "submit")
    end

    it "includes CSRF token" do
      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_css("input[name='authenticity_token']", visible: false)
    end

    it "includes form submission handling" do
      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_css("form[data-action='submit->task-form#submit']")
    end

    it "includes loading state handling" do
      component = described_class.new(current_user: current_user)

      render_inline(component)

      expect(page).to have_css("[data-task-form-target='submitButton']")
      expect(page).to have_css("[data-task-form-target='loadingSpinner']", visible: false)
    end
  end
end
