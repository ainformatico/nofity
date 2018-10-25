class InvitationRequestsController < ApplicationController
  skip_before_filter :authenticate_user!

  layout 'invitation-request'

  def create
    @invitation_request = create_invitation
  end

  def update
    @invitation_request = create_invitation(invitation_request_params)
    if @invitation_request.save
      render action: :show
    else
      render action: :create
    end
  end

  private

  def create_invitation(options = {})
    InvitationRequest.new(options)
  end

  def invitation_request_params
    params.require(:invitation_request).permit(:email)
  end
end
