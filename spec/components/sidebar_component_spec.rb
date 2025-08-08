# frozen_string_literal: true

require "rails_helper"

RSpec.describe SidebarComponent, type: :component do
  let(:user) { create(:user, pseudo: "testuser") }

  describe "rendering" do
    it "renders the sidebar with application name" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".sidebar")
      expect(page).to have_css(".app-name", text: "ChatToDo")
    end

    it "renders the user pseudo in the footer" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".user-button", text: "testuser")
    end

    it "includes the logout link in dropdown" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".user-dropdown", visible: false)
      expect(page).to have_link("Logout", href: "/logout", visible: false)
    end

    it "has resize handle for adjusting width" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".resize-handle")
    end

    it "includes Stimulus controller data attributes" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".sidebar[data-controller='sidebar']")
      expect(page).to have_css("[data-sidebar-target='userMenu']")
      expect(page).to have_css("[data-sidebar-target='dropdown']", visible: false)
      expect(page).to have_css("[data-sidebar-target='resizeHandle']")
    end

    it "has correct action bindings" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css("[data-action='click->sidebar#toggleUserMenu']")
      expect(page).to have_css("[data-action='mousedown->sidebar#startResize']")
    end

    it "sets default width CSS variable" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".sidebar[style*='--sidebar-width: 13vw']")
    end

    it "has dropdown initially hidden" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".user-dropdown[style*='display: none']", visible: false)
    end

    it "includes create task button" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".create-task-button")
      expect(page).to have_button("Create Task")
      expect(page).to have_css("[data-action='click->sidebar#openTaskModal']")
    end

    it "displays task lists for created and assigned tasks" do
      created_task = create(:task, title: "My Created Task")
      assigned_task = create(:task, title: "My Assigned Task")
      
      create(:task_user, user: user, task: created_task, role: TaskUser::CREATOR)
      create(:task_user, user: user, task: assigned_task, role: TaskUser::ASSIGNEE)

      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".task-list", count: 2)
      expect(page).to have_text("Created by me")
      expect(page).to have_text("Assigned to me")
    end

    it "shows empty states when user has no tasks" do
      component = described_class.new(user: user)

      render_inline(component)

      expect(page).to have_css(".task-list-empty", count: 2)
      expect(page).to have_text("No tasks found")
    end
  end
end
