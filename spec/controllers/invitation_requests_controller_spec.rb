require 'spec_helper'

describe InvitationRequestsController do
  let(:user) { create(:user) }
  let(:valid_attributes) { { email: user.email } }

  describe 'GET create' do
    it 'shows the invitation form' do
      get :create
      expect(response).to render_template('create')
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new InvitationRequest' do
        expect do
          post :update, invitation_request: valid_attributes
        end.to change(InvitationRequest, :count).by(1)
      end

      it 'assigns a newly created invitation_request as @invitation_request' do
        post :update, invitation_request: valid_attributes
        expect(assigns(:invitation_request)).to be_a(InvitationRequest)
        expect(assigns(:invitation_request)).to be_persisted
      end

      it 'redirects to the created invitation_request' do
        post :update, invitation_request: valid_attributes
        expect(response).to render_template('show')
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved invitation_request as @invitation_request' do
        expect_any_instance_of(InvitationRequest).to receive(:save).and_return(false)
        post :update, invitation_request: { foo: :bar }
        expect(assigns(:invitation_request)).to be_a_new(InvitationRequest)
      end

      it "re-renders the 'new' template" do
        expect_any_instance_of(InvitationRequest).to receive(:save).and_return(false)
        post :update, invitation_request: { foo: :bar }
        expect(response).to render_template('create')
      end
    end
  end
end
