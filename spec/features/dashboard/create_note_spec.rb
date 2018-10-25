require 'features/features_helper'
require 'features/helpers'

feature "user's custom dashboard", js: true do
  include Helpers

  before do
    @user = fake_sign_in('john')
  end

  it 'should create a note' do
    text = create_note
    expect(page).to have_text(text)
  end

  it 'should create and add a category with sharp' do
    note_text = 'a new with a #category'
    create_note(note_text)

    expect(page).to have_css('.note')
    expect(page).to have_text('#category')
  end

  it 'should remove a note' do
    create_and_delete_note
  end
end
