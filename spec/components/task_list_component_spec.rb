# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskListComponent, type: :component do
  include Rails.application.routes.url_helpers
  let(:user) { create(:user) }
  let(:task1) { create(:task, title: "First Task") }
  let(:task2) { create(:task, title: "Second Task with a Very Long Title That Should Be Truncated") }
  
  describe "rendering" do
    it "renders a task list with title and tasks" do
      tasks = [task1, task2]
      component = described_class.new(title: "My Tasks", tasks: tasks)

      render_inline(component)

      expect(page).to have_css(".task-list")
      expect(page).to have_css(".task-list-title", text: "My Tasks")
    end

    it "renders individual task items" do
      tasks = [task1, task2]
      component = described_class.new(title: "My Tasks", tasks: tasks)

      render_inline(component)

      expect(page).to have_css(".task-item", count: 2)
      expect(page).to have_link(href: task_path(task1))
      expect(page).to have_link(href: task_path(task2))
      expect(page).to have_text("##{task1.title}")
      expect(page).to have_text("#Second Task with a Ver...")  # Truncated version
    end

    it "shows empty state when no tasks" do
      component = described_class.new(title: "My Tasks", tasks: [])

      render_inline(component)

      expect(page).to have_css(".task-list-empty")
      expect(page).to have_text("No tasks found")
    end

    it "includes task state indicators" do
      todo_task = create(:task, title: "Todo Task", state: Task::TODO)
      ongoing_task = create(:task, title: "Ongoing Task", state: Task::ONGOING)
      tasks = [todo_task, ongoing_task]
      
      component = described_class.new(title: "My Tasks", tasks: tasks)

      render_inline(component)

      expect(page).to have_css(".task-state-todo")
      expect(page).to have_css(".task-state-ongoing")
    end

    it "truncates long task titles" do
      long_task = create(:task, title: "This is a very long task title that should be truncated")
      component = described_class.new(title: "My Tasks", tasks: [long_task])

      render_inline(component)

      # The component should have the full title as title attribute for accessibility
      expect(page).to have_css(".task-title[title='#{long_task.title}']")
    end
  end
end