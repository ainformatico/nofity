require 'spec_helper'

describe PublicNotesController, type: :controller do
  render_views

  let(:user) { create(:user) }

  before do
    create(:note, user: user, public: true)
    create(:note, user: user, public: true)
  end

  describe 'user is not logged in' do
    it 'shows all public notes' do
      check_notes
    end
  end

  describe 'user is logged in' do
    before do
      sign_in(user)
    end

    it 'shows all public notes' do
      check_notes
    end
  end

  private

  def check_notes
    get :index, format: :json
    expect(parsed_body.length).to eq(2)
  end
end
