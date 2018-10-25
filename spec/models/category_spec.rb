require 'spec_helper'

describe Category do
  let(:user) { create(:user) }

  it 'is invalid without user' do
    category = build(:category, user: nil)
    expect(category).to_not be_valid
  end

  it 'is invalid without name' do
    category = build(:category, user: user, name: nil)
    expect(category).to_not be_valid
  end

  it 'creates a category' do
    category = create(:category, user: user, name: 'foo')
    expect(category.name).to eq('foo')
  end

  it "returns users's visible categories" do
    category = create(:category, user: user)
    new_category = create(:category, user: user)
    new_category.remove
    expect(user.categories).to match_array([category])
  end
end
