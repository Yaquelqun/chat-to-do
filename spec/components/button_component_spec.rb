# frozen_string_literal: true

require "rails_helper"

RSpec.describe ButtonComponent, type: :component do
  describe "rendering" do
    it "renders a button with text" do
      component = described_class.new(text: "Click me")

      render_inline(component)

      expect(page).to have_button("Click me")
      expect(page).to have_css("button")
    end

    it "renders with custom attributes" do
      component = described_class.new(text: "Submit", type: "submit")

      render_inline(component)

      expect(page).to have_css("button[type='submit']")
      expect(page).to have_button("Submit")
    end

    it "renders with data attributes" do
      component = described_class.new(text: "Click", data: { action: "click->test#handle" })

      render_inline(component)

      expect(page).to have_css("button[data-action='click->test#handle']")
      expect(page).to have_button("Click")
    end
  end
end
