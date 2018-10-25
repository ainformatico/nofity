require 'spec_helper'

describe Note do
  let(:user) { create(:user) }

  it 'is invalid without user' do
    note = build(:note, user: nil)
    expect(note).to_not be_valid
  end

  it 'is valid without content' do
    note = build(:note, user: user, content: nil)
    expect(note).to be_valid
  end

  it 'creates a note' do
    note = create(:note, user: user, content: 'foo')
    expect(note.content).to eq('foo')
  end

  it "returns users's visible notes" do
    note = create(:note, user: user)
    new_note = create(:note, user: user)
    new_note.remove
    expect(user.notes).to match_array([note])
  end

  context 'methods' do
    before do
      @note1 = create(:note, user: user)
      @note2 = create(:note, user: user)
      @public_note = create(:note_public, user: user)
      @other_user = create(:jdoe)
      @public_note_other_user = create(:note_public, user: @other_user)
    end

    context '#private_or_public' do
      it 'returns note for user' do
        expect(Note.private_or_public(user, @note1.idsec)).to eq(@note1)
      end

      it 'returns notes for user' do
        expect(Note.private_or_public(user))
          .to(match_array([@note1, @note2, @public_note]))
      end

      it 'returns public note from other user' do
        expect(Note.private_or_public(user, @public_note_other_user.idsec))
          .to(eq(@public_note_other_user))
      end
    end

    context '#for_user' do
      it 'returns all the notes for a user' do
        expect(Note.for_user(user))
          .to(match_array([@note1, @note2, @public_note]))
      end

      it 'returns one note for a user' do
        expect(Note.for_user(user, @note1.idsec)).to eq(@note1)
      end
    end
  end

  context 'categories' do
    before :each do
      @category = create(:category, user: user)
      @note = create(:note, user: user)
      @note.categories << @category
    end

    it 'assings a category' do
      expect(@note).to be_valid
      expect(@note.categories).to match_array([@category])
    end

    it 'removes a category' do
      expect do
        @note.categories.find(@category.id).delete
      end.to change(@note.categories, :count).by(-1)
    end
  end
end
