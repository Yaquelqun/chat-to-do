require "rails_helper"

RSpec.describe <%= component_class_name %>, type: :component do
  describe "rendering" do
    it "renders the component" do
      component = described_class.new

      render_inline(component)

      expect(page).to have_css(".<%= file_name %>-component")
    end
  end
end