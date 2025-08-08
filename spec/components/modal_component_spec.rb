# frozen_string_literal: true

require "rails_helper"

RSpec.describe ModalComponent, type: :component do
  describe "rendering" do
    it "renders a modal with title and content" do
      component = described_class.new(id: "test-modal", title: "Test Modal")

      render_inline(component) do
        "Modal content"
      end

      expect(page).to have_css("[data-controller='modal']")
      expect(page).to have_css(".modal-backdrop")
      expect(page).to have_css(".modal-dialog")
      expect(page).to have_css(".modal-header")
      expect(page).to have_css(".modal-title", text: "Test Modal")
      expect(page).to have_css(".modal-body", text: "Modal content")
    end

    it "includes close button" do
      component = described_class.new(id: "test-modal", title: "Test Modal")

      render_inline(component) do
        "Content"
      end

      expect(page).to have_css(".modal-close")
      expect(page).to have_css("[data-action='click->modal#close']")
    end

    it "includes backdrop close functionality" do
      component = described_class.new(id: "test-modal", title: "Test Modal")

      render_inline(component) do
        "Content"
      end

      expect(page).to have_css(".modal-backdrop[data-action='click->modal#closeOnBackdrop']")
    end

    it "includes keyboard close functionality" do
      component = described_class.new(id: "test-modal", title: "Test Modal")

      render_inline(component) do
        "Content"
      end

      expect(page).to have_css("[data-action='keydown.escape->modal#close']")
    end

    it "has proper modal attributes" do
      component = described_class.new(id: "test-modal", title: "Test Modal")

      render_inline(component) do
        "Content"
      end

      expect(page).to have_css("#test-modal")
      expect(page).to have_css("[role='dialog']")
      expect(page).to have_css("[aria-labelledby]")
      expect(page).to have_css("[aria-hidden='true']")
    end
  end
end
