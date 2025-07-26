# Unit tested in spec/controllers/dashboard_controller_spec.rb
class DashboardController < ApplicationController
  before_action :require_user

  def show
    @user = current_user
  end
end
