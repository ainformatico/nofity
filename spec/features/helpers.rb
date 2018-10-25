module Helpers
  def create_note(note_text = false)
    text = note_text || 'simple note'
    visit dashboard_path
    fill_in 'dashboard-input', with: text
    click_button I18n.t('form.create')
    text
  end

  def create_public_note_other_user
    other_user = create(:jdoe)
    create(:note_public, user: other_user)
  end

  def check_note_other_user(url)
    visit url
    expect(page).to_not have_css('.js-delete')
  end

  def check_deleted_note(text, url)
    visit url
    expect(page).to have_text(text)
    click_button I18n.t('actions.buttons.delete')
    expect(page).to_not have_text(text)
  end

  def create_and_delete_note
    text = create_note
    check_deleted_note(text, note_index_path)
  end
end
