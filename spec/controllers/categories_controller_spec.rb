require 'spec_helper'

describe CategoriesController do
  let(:user) { create(:user) }
  let(:valid_attributes) { { name: 'category name', user: user } }

  before :each do
    sign_in(user)
  end

  describe 'GET index' do
    it 'assigns all categories as @categories' do
      category = create(:category, valid_attributes)
      get :index
      expect(assigns(:categories)).to eq([category])
    end
  end

  describe 'GET show' do
    it 'assigns the requested category as @category' do
      category = create(:category, valid_attributes)
      get :show, id: category.idsec
      expect(assigns(:category)).to eq(category)
    end

    it 'returns the notes for that category' do
      category = create(:category, user: user)
      note = create(:note, user: user, categories: [category])
      get :show, id: category.idsec
      expect(assigns(:notes)).to match_array([note])
      expect(response).to be_success
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Category' do
        expect do
          post :create, category: attributes_for(:category, valid_attributes), format: :json
          user.categories.reload
        end.to change(user.categories, :count).by(1)
      end
    end

    describe 'with invalid params' do
      it 'request with wrong parameters' do
        post :create, category: attributes_for(:category)
        expect(response).not_to be_bad_request
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested category' do
        new_content = 'new content'
        category = create(:category, valid_attributes)
        put :update, id: category.idsec, category: attributes_for(:category, name: new_content)
        expect(category.reload.name).to eq(new_content)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested category' do
      category = create(:category, valid_attributes)
      expect do
        delete :destroy, id: category.idsec
      end.to change(user.categories, :count).by(-1)
    end
  end
end
