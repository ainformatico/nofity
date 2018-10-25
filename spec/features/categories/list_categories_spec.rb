require 'features/features_helper'
require 'features/helpers'

feature 'list categories of a note', js: true do
  include Helpers

  before do
    @user = fake_sign_in('john')
  end

  it 'should go to a category from a note' do
    category_name = '#category'

    2.times do |index|
      create_note "my first note #{index} #{category_name}"
    end

    visit note_index_path

    links = page.all('.link')
    links.first.click
    expect(links.count).to eq(2)
    expect(page.current_path).to eq(category_path(Category.first.reload.idsec))
    expect(page).to have_text(text)
  end
end
