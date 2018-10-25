require 'spec_helper'

describe Link do
  let(:user) { create(:user) }

  it 'is invalid without a url' do
    link = build(:link, url: nil)
    expect(link).to_not be_valid
  end

  it 'creates a link' do
    url = 'https://www.google.com'
    link = create(:link, user: user, url: url)
    expect(link.url).to eq(url)
  end

  it "returns users's visible links" do
    link = create(:link, user: user)
    new_link = create(:link, user: user)
    new_link.remove
    expect(user.links).to match_array([link])
  end
end
