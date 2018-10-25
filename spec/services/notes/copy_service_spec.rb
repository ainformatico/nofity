require 'spec_helper'

describe Notes::CopyService do
  let(:original_user) { create(:user) }
  let(:destination_user) { create(:jdoe) }

  describe 'copy note without link' do
    it 'copies a note from other user' do
      original_note = create(:note, user: original_user)

      copied_note = ::Notes::CopyService.new(original_note, destination_user).copy
      expect(copied_note.user).to eq(destination_user)
      expect(copied_note.content).to eq(copied_note.content)
    end
  end

  describe 'copy note with link' do
    it 'copies a note from other user' do
      link = create(:link, user: original_user)
      original_note = create(:note, user: original_user, link: link)

      copied_note = ::Notes::CopyService.new(original_note, destination_user).copy
      expect(copied_note.link.user).to eq(destination_user)
    end

    it 'creates a log entry' do
      link = create(:link, user: original_user)
      original_note = create(:note, user: original_user, link: link)
      copied_note = ::Notes::CopyService.new(original_note, destination_user)

      expect { copied_note.copy }.to change(CopiedNote, :count).by(1)

      log = CopiedNote.first

      expect(log.from).to eq(original_user)
      expect(log.to).to eq(destination_user)
      expect(log.note).to eq(original_note)
      expect(log.link).to eq(link)
    end
  end
end
