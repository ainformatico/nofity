require 'spec_helper'

describe NoteController do
  render_views

  let(:user) { create(:user) }
  let(:note) { create(:note, user: user, content: 'note content') }
  let(:public_note) { create(:note_public, user: user, content: 'public note content') }

  describe 'user is not logged' do
    context 'do not passing user as parameter' do
      it 'returns forbidden' do
        get :index
        expect(response).to redirect_to user_session_path
      end
    end

    context 'passing note id as parameter' do
      it 'returns forbidden' do
        get :show, id: note.idsec
        expect(response).to be_not_found
      end

      it 'returns public note' do
        get :show, id: public_note.idsec
        expect(response).to be_success
      end
    end
  end

  describe 'user is logged' do
    before :each do
      sign_in(user)
    end

    context 'other user' do
      it "cannot edit other user's notes" do
        other_user = create(:jdoe)
        other_user_note = create(:note_public, user: other_user)
        get :edit, id: other_user_note.idsec
        expect(response).to be_not_found
      end
    end

    context 'index' do
      it 'renders index template' do
        get :index
        expect(response).to render_template('index')
      end

      it "returns user's notes" do
        note = create(:note, user: user)

        get :index
        expect(assigns(:notes)).to match_array([note])
      end
    end

    context 'show' do
      it 'renders show template' do
        get :show, id: note.idsec
        expect(response).to render_template('layouts/application')
      end

      it 'returns a note' do
        note = create(:note, user: user)

        get :show, id: note.idsec
        expect(assigns(:note)).to eq(note)
      end

      it 'sets link to null if no link found' do
        note = create(:note, user: user, content: 'No link set')
        get :show, id: note.idsec, format: :json

        expect(parsed_body['link']).to be_nil
      end

      it 'return public note from user' do
        get :show, id: public_note.idsec, format: :json
        expect(response).to be_success
        expect(parsed_body[:id]).to be
        expect(parsed_body[:public]).to be
      end

      it 'returns public note from othe user' do
        other_user = create(:jdoe)
        other_user_note = create(:note_public, user: other_user)
        get :show, id: other_user_note.idsec, format: :json
        expect(parsed_body[:id]).to be
        expect(parsed_body[:public]).to be
      end
    end

    context 'update' do
      before :each do
        @note = create(:note, user: user)
      end

      it 'returns success' do
        put :update, id: @note.idsec, note: attributes_for(:note, {}), format: :json
        expect(response).to be_success
      end

      it 'returns ok request when no data is sent' do
        put :update, id: @note.idsec, format: :json
        expect(response).to be_ok
      end

      it 'updates the note' do
        new_content = 'new content'
        put :update, id: @note.idsec, note: attributes_for(:note, content: new_content)
        expect(@note.reload.content).to eq(new_content)
      end

      it 'does not update the note with wrong data' do
        new_content = 'new content'
        put :update, id: @note.idsec, note: attributes_for(:note, body: new_content, user: user, categories: [{ id: 1, name: 'foo' }])
        expect(@note.reload.content).to_not eq(new_content)
      end

      context 'PATCH' do
        it 'updates only the visibility' do
          old_content = @note.content
          patch :update, id: @note.idsec, note: { public: true }
          @note.reload
          expect(@note.public).to be
          expect(@note.content).to eq(old_content)
        end

        it 'updates with one link' do
          link = create(:link, user: user)
          expect(@note.link).to_not be
          @note.link = link
          patch :update, id: @note.idsec, note: { public: true }
          @note.reload
          expect(@note.link).to be_valid
        end
      end
    end

    context 'destroy' do
      before :each do
        @note = create(:note, user: user)
      end

      it 'deletes a note' do
        delete :destroy, id: @note.idsec
        expect(user.notes.count).to eq(0)
        expect(response).to be_success
      end
    end

    context 'create' do
      it 'creates a note' do
        params = {
          content: 'my new note'
        }

        post :create, note: attributes_for(:note, params)
        user.notes.reload
        expect(user.notes.count).to eq(1)
        expect(response).to be_success
      end

      it 'creates a note with a category at the end' do
        check_category_for_note('my new note #category1')
      end

      it 'creates a note with a category in the middle' do
        check_category_for_note('my #category1 in my new note')
      end

      it 'creates a note with a category at the start' do
        check_category_for_note('#category is at the begining')
      end

      it 'creates a note without link' do
        post :create, note: attributes_for(:note, content: 'No link')
        note = user.notes.first

        expect(note.link).to_not be
        expect(response).to be_success
      end

      it 'fails when creating a new due the lack of params' do
        expect do
          post :create, note: {}, format: :json
        end.to_not change(User, :count)
        expect(response).to be_bad_request
      end
    end
  end
end

private

def check_category_for_note(text)
  params = {
    content: text
  }

  post :create, note: attributes_for(:note, params)
  note = user.notes.first
  expect(note.categories.first).to eq(user.categories.first)
  expect(note.content).to eq(params[:content])
  expect(response).to be_success
end
