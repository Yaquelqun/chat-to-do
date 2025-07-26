# Unit tested in spec/controllers/dashboard_controller_spec.rb
class DashboardController < ApplicationController
  def show
    # Given that this is route is the root path
    # We don't want to show an error flash if the user it not logged it
    redirect_to login_path and return unless logged_in?
    @user = current_user
  end
end
