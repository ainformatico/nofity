require 'spec_helper'

describe UserController do
  describe 'user is confirmed' do
    let(:user) { create(:user) }

    before :each do
      @user = sign_in(user)
    end

    describe '#GET' do
      it 'returns a json with the current user data' do
        get :index, format: :json
        expect(response).to render_template('index')
        expect(response).to be_success
        expect(assigns(:user)).to eq(user)
      end

      it 'do not process if the request is different than JSON' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # describe 'use is not confirmed' do
  # before do
  # user = create(:user_unconfirmed)
  # sign_in(user)
  # end

  # it 'should redirect to login page' do
  # get :index
  # expect(response).to redirect_to(user_session_path)
  # end

  # it 'should show an error response' do
  # get :index, format: :json
  # # rspec does not have be_unauthorized
  # expect(response.status).to eq(401)
  # expect(parsed_body).to have_key(:error)
  # end
  # end
end
