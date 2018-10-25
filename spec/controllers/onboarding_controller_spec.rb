require 'spec_helper'

include OnboardingHelper

describe OnboardingController do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
  end

  describe 'PUT update' do
    it 'sets user as onboarded' do
      name = 'initial'
      put :update, id: name, format: :json
      expect(Featurer.on?(onboarding_name(name), user.id)).to be
    end
  end
end
