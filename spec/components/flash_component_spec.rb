# frozen_string_literal: true

require "rails_helper"

RSpec.describe FlashComponent, type: :component do
  describe "rendering" do
    it "renders a notice flash message" do
      component = described_class.new(type: :notice, message: "Success!")

      render_inline(component)

      expect(page).to have_css(".flash-notice")
      expect(page).to have_text("Success!")
    end

    it "renders an alert flash message" do
      component = described_class.new(type: :alert, message: "Error!")

      render_inline(component)

      expect(page).to have_css(".flash-alert")
      expect(page).to have_text("Error!")
    end

    it "includes a close button" do
      component = described_class.new(type: :notice, message: "Test")

      render_inline(component)

      expect(page).to have_css("button.flash-close")
      expect(page).to have_css("button[data-action='click->flash#close']")
    end

    it "includes Stimulus controller data attributes" do
      component = described_class.new(type: :notice, message: "Test")

      render_inline(component)

      expect(page).to have_css("[data-controller='flash']")
      expect(page).to have_css("[data-flash-auto-dismiss-value='5000']")
    end
  end
end
