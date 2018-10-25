require 'spec_helper'
require 'features/features_helper'

feature 'user id admin' do
  context 'admin is logged in' do
    before do
      @user = fake_sign_in('admin')
    end

    it 'sees the sidekiq page' do
      visit sidekiq_web_path
      expect(page).to have_text('Sidekiq')
    end
  end

  context 'admin is not logged in' do
    before do
      @user = fake_sign_in('john')
    end

    it 'sees the sidekiq page' do
      expect  do
        visit sidekiq_web_path
      end.to raise_error(ActionController::RoutingError)
    end
  end
end
