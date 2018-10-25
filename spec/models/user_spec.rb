require 'spec_helper'

describe User do
  subject { create(:user) }

  context 'creation' do
    it 'creates a new user' do
      expect(subject.email).to eq('john@doe.com')
    end

    it 'does not allow repeated username or email' do
      # http://stackoverflow.com/a/8439416
      create(:jdoe)
      expect(build(:jdoe)).not_to be_valid
    end
  end

  context 'validation' do
    it 'checks the username' do
      expect(build(:jdoe).username).to eq 'jdoe'
    end
  end

  context 'notes' do
    it "returns users's notes" do
      note = create(:note, user: subject)
      expect(subject.notes).to match_array([note])
    end
  end

  context 'admin' do
    it 'should have the admin attribute' do
      admin = create(:admin)
      expect(admin.admin?).to be
    end

    it 'should not have the admin attribute' do
      admin = create(:jdoe)
      expect(admin.admin?).not_to be
    end
  end
end
