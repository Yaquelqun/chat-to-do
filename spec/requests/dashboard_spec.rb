require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:user) { create(:user) }

  describe "GET /dashboard" do
    context "when user is authenticated" do
      before do
        session_params = { user_id: user.id }
        allow_any_instance_of(ApplicationController).to receive(:session).and_return(session_params)
      end

      it "returns http success" do
        get "/dashboard"
        expect(response).to have_http_status(:success)
      end

      xit "displays user information" do
        get "/dashboard"
        expect(response.body).to include(user.pseudo)
        expect(response.body).to include(user.email)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login page" do
        get "/dashboard"
        expect(response).to redirect_to(login_path)
      end

      it "sets alert flash message" do
        get "/dashboard"
        follow_redirect!
        expect(response.body).to include("You must be logged in to perform that action")
      end
    end
  end
end
