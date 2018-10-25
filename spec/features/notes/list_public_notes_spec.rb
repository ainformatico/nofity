require 'features/features_helper'
require 'features/helpers'

feature 'list notes public notes', js: true do
  include Helpers

  before do
    @user = fake_sign_in('john')
    create(:note, user: @user)
  end

  it 'should list all public notes' do
    visit public_notes_path
    expect(page).to have_css('.note')
  end

  it 'should show public note from other user' do
    create_public_note_other_user
    check_note_other_user(public_notes_path)
  end

  it "should copy a note from other user into current user's note" do
    create_public_note_other_user
    visit public_notes_path

    expect(page).to have_css('.js-copy')
    click_button I18n.t('actions.buttons.copy')
    expect(page).to have_css('.js-delete')
  end
end
