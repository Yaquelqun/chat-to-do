# frozen_string_literal: true

require "rails_helper"

RSpec.describe CollapsiblePanelComponent, type: :component do
  describe "rendering" do
    it "renders a collapsible panel with title and content" do
      component = described_class.new(title: "Test Panel")

      render_inline(component) do
        "Panel content"
      end

      expect(page).to have_css(".collapsible-panel")
      expect(page).to have_css(".panel-header")
      expect(page).to have_css(".panel-title", text: "Test Panel")
      expect(page).to have_css(".panel-content", text: "Panel content")
    end

    it "renders collapsed by default" do
      component = described_class.new(title: "Test Panel")

      render_inline(component) do
        "Panel content"
      end

      expect(page).to have_css(".collapsible-panel.collapsed")
      expect(page).to have_css(".panel-content[aria-hidden='true']")
    end

    it "renders expanded when collapsed is false" do
      component = described_class.new(title: "Test Panel", collapsed: false)

      render_inline(component) do
        "Panel content"
      end

      expect(page).to have_css(".collapsible-panel:not(.collapsed)")
      expect(page).to have_css(".panel-content[aria-hidden='false']")
    end

    it "includes Stimulus controller and data attributes" do
      component = described_class.new(title: "Test Panel")

      render_inline(component) do
        "Panel content"
      end

      expect(page).to have_css("[data-controller='collapsible-panel']")
      expect(page).to have_css("[data-action='click->collapsible-panel#toggle']")
      expect(page).to have_css("[data-collapsible-panel-target='content']")
    end

    it "includes toggle indicator" do
      component = described_class.new(title: "Test Panel")

      render_inline(component) do
        "Panel content"
      end

      expect(page).to have_css(".panel-toggle")
    end

    it "has proper accessibility attributes" do
      component = described_class.new(title: "Test Panel", id: "test-panel")

      render_inline(component) do
        "Panel content"
      end

      expect(page).to have_css("#test-panel")
      expect(page).to have_css("[aria-labelledby]")
      expect(page).to have_css("[aria-expanded]")
    end

    it "uses generated id when none provided" do
      component = described_class.new(title: "Test Panel")

      render_inline(component) do
        "Panel content"
      end

      expect(page).to have_css("[id^='collapsible-panel-']")
    end

    it "includes two-column content layout" do
      component = described_class.new(title: "Test Panel")

      render_inline(component) do
        "Panel content"
      end

      expect(page).to have_css(".panel-content-grid")
    end
  end
end
