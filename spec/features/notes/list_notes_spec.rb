require 'features/features_helper'
require 'features/helpers'

feature 'list notes for user', js: true do
  include Helpers

  before do
    @user = fake_sign_in('john')
  end

  it 'should show public note from other user' do
    other_user = create(:jdoe)
    other_user_note = create(:note_public, user: other_user)
    check_note_other_user(other_user_note.idsec)
  end

  it "should show user's notes" do
    text = 'my first note'
    create(:note, user: @user, content: text)
    visit note_index_path
    expect(page).to have_css('.list')
    expect(page).to have_text(text)
  end

  it 'should remove a note' do
    create_and_delete_note
  end
end
