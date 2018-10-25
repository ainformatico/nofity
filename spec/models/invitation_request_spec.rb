require 'spec_helper'

describe InvitationRequest do
  let(:user) { create(:user) }

  it 'is invalid without an email' do
    invitation_request = build(:invitation_request, email: nil)
    expect(invitation_request).not_to be_valid
  end

  it 'is invalid with a non-email field' do
    invitation_request = build(:invitation_request, email: 'foo')
    expect(invitation_request).not_to be_valid
  end

  it 'creates a invitation_request' do
    invitation_request = create(:invitation_request, email: user.email)
    expect(invitation_request.email).to eq(user.email)
  end

  it 'returns all the invitations' do
    invitation_request = create(:invitation_request, email: user.email)
    new_invitation_request = create(:invitation_request, email: user.email)
    expect(InvitationRequest.all).to match_array([invitation_request, new_invitation_request])
  end
end
