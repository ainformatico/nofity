require 'features/features_helper'

feature 'show note for user', js: true do
  describe 'user is logged in' do
    before do
      @user = fake_sign_in('john')
      @note = create(:note, user: @user)
    end

    describe 'note exists' do
      it 'should see the enhanced page' do
        visit_note
        expect(page).to have_text(@note.content)
        expect(page).to_not have_css('#mobile')
      end
    end

    describe 'note does not exist' do
      it 'should see not found message' do
        visit note_path(id: @note.id)

        expect(page).to have_text(I18n.t('note.empty.title'))
      end
    end
  end

  describe 'user is not logged in' do
    before do
      @user = create(:user)
      @note = create(:note, user: @user)
    end

    describe 'note is public' do
      before do
        @note.update_attribute(:public, true)
      end

      describe 'note exists' do
        describe 'note has link' do
          before do
            @note.link = create(:link, user: @user)
          end

          it 'should see the public page' do
            visit_note
            check_note_in_page
          end
        end

        describe 'note does not have link' do
          it 'should see the public page' do
            visit_note
            check_note_in_page
          end
        end
      end

      describe 'note does not exist' do
        it 'should see the public page and 404 code' do
          visit note_path(id: @note.id)
          expect(page.status_code).to be 404
        end
      end
    end

    def check_note_in_page
      expect(page).to have_text(@note.content)
      expect(page).to have_css('#cta')
    end
  end

  def visit_note
    visit note_path(id: @note.idsec)
  end
end
