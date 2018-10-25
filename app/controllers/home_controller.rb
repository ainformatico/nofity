class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]

  layout 'home'

  def index
    if current_user
      redirect_to dashboard_path
    else
      @invitation_request = InvitationRequest.new
    end
  end
end
