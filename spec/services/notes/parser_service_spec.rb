require 'spec_helper'

describe Notes::ParserService do
  describe 'note parsing' do
    let(:user) { create(:user) }
    let(:text) { 'this is my category' }
    let(:category1) { 'category1' }
    let(:category2) { 'category2' }
    let(:category3) { 'category3' }

    it 'should return #category1' do
      raw_text = "#{text} ##{category1}"
      data = {
        content: raw_text,
        user: user
      }
      parsed = Notes::ParserService.new(data).parse.to_hash
      expect(parsed).to eq(
        content: raw_text,
        categories: [find_category_by_name(category1)],
        link: nil
      )
    end

    it 'to return #category2' do
      raw_text = "##{category2} #{text}"
      data = {
        content: raw_text,
        user: user
      }
      parsed = Notes::ParserService.new(data).parse.to_hash
      expect(parsed).to eq(
        content: raw_text,
        categories: [find_category_by_name(category2)],
        link: nil
      )
    end

    it 'should return #category3' do
      raw_text = "this is ##{category3} on my note"
      data = {
        content: raw_text,
        user: user
      }
      parsed = Notes::ParserService.new(data).parse.to_hash
      expect(parsed).to eq(
        content: raw_text,
        categories: [find_category_by_name(category3)],
        link: nil
      )
    end

    it 'should return a list of categories' do
      raw_text = "#{text} ##{category1} ##{category2} ##{category3}"
      data = {
        content: raw_text,
        user: user
      }
      parsed = Notes::ParserService.new(data).parse.to_hash
      expect(parsed).to eq(
        content: raw_text,
        categories: [find_category_by_name(category1), find_category_by_name(category2), find_category_by_name(category3)],
        link: nil
      )
    end

    it 'should return an empty list' do
      data = {
        content: text,
        user: user
      }
      parsed = Notes::ParserService.new(data).parse.to_hash
      expect(parsed).to eq(
        content: text,
        categories: [],
        link: nil
      )
    end

    it 'removes the link from a note' do
      url = 'http://cordova.apache.org/docs/en/3.4.0/guide_platforms_android_index.md.html#Android%20Platform%20Guide'
      link = create(:link, url: url, user: user)
      joined = "#{text} #{url}"
      data = {
        content: joined,
        user: user
      }
      allow_any_instance_of(Notes::ParserService).to receive(:parse_link).and_return(link)
      parsed = Notes::ParserService.new(data).parse.to_hash
      expect(parsed).to eq(
        content: text,
        categories: [],
        link: link
      )
    end

    it 'should return the link inside the note' do
      content = 'this is my note www.nofity.com and is awesome www.google.com'
      link = { url: 'www.nofity.com', indices: [16, 30] }
      data = {
        content: content,
        user: user
      }
      parsed = Notes::ParserService.new(data).extract_link
      expect(parsed).to eq(link)
    end

    it 'should create an empty object' do
      data = {
        content: nil,
        user: user
      }
      parsed = Notes::ParserService.new(data).parse
      expect(parsed.content).to eq('')
    end

    it 'should queue the job' do
      data = {
        content: 'thebrainstorms.com',
        user: user
      }

      # NOTE: we know we are creating only one link in this test
      expect(Notes::LinkFetcher).to receive(:queue).with(1, user.id)
      Notes::ParserService.new(data).parse
    end
  end

  def find_category_by_name(name)
    Category.find_by(name: name)
  end
end
