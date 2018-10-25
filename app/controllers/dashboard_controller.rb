class DashboardController < ApplicationController
  def index
    @notes = current_user.notes
  end
end
