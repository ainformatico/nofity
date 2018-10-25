require 'features/features_helper'

feature 'edit note for user', js: true do
  before do
    @user = fake_sign_in('john')
    @note = create(:note, user: @user)
  end

  it 'should edit user note', js: true do
    text = 'new content'
    visit note_index_path
    expect(page).to have_text(@note.content)

    click_button I18n.t('actions.buttons.edit')

    fill_in 'content', with: text
    click_on I18n.t('form.save')

    expect(page).to have_text(text)
  end

  it 'should edit note visibility', js: true do
    checkbox_text = I18n.t('note.details.public')
    visit note_index_path

    expect(@note.public).to_not be
    page.check(checkbox_text)
    expect(find_field(checkbox_text)).to be_checked
  end
end
