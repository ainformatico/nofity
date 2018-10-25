module Notes
  class ParserService
    attr_reader :content, :categories

    def initialize(data)
      @data = data
      @user = data[:user]
    end

    def to_hash
      {
        content: @content,
        categories: @categories,
        link: @link
      }
    end

    def parse
      @data = parse_note(@data[:content])
      self
    end

    def link
      if @link == {}
        nil
      else
        @link
      end
    end

    def parse_categories(content)
      categories = extract_category_from_input(content)
      init_categories(categories)
    end

    def parse_link(content)
      link = extract_link_from_input(content)
      init_link(link)
    end

    def extract_link
      extract_link_from_input(@data[:content])
    end

    private

    def parse_note(text = '')
      text = '' if text.nil?
      content = extract_content_from_input(text)
      categories = parse_categories(content)
      link = parse_link(content)
      content = clean_link_from_input(content)
      @content = content
      @categories = categories
      @link = link
    end

    def extract_content_from_input(text)
      trim(text)
    end

    def trim(text)
      text.gsub(/^\s*/, '').gsub(/\s*$/, '')
    end

    def extract_category_from_input(text)
      categories = Twitter::Extractor.extract_hashtags(text)
      categories.map do |category|
        { name: category }
      end
    end

    def init_category(category)
      if category[:idsec]
        category[:idsec] = category[:id]
        category.delete :id
      end
    end

    def find_or_initialize_category(category)
      item = @user.categories.find_or_initialize_by(category)

      if item.new_record?
        item.update_attribute(:idsec, nil) # prevent saving the idsec(in params is id:)
        item.save
      end

      item
    end

    def init_categories(categories)
      return [] unless categories

      categories.map do |category|
        init_category(category)
        find_or_initialize_category(category)
      end
    end

    def clean_link_from_input(text)
      text.sub!(/\s?#{extract_link[:url]}/, '')
    end

    def extract_link_from_input(text)
      UrlExtractor.extract(text)
    end

    def init_link(link_data)
      if link_data[:url]
        url = UrlParser.create(link_data[:url])
        link = @user.links.find_by(raw_url: url)
        unless link
          link = @user.links.create(url: url, raw_url: url, title: url, description: url)
          LinkFetcher.queue(link.id, @user.id)
        end

        link
      end
    end
  end

  class LinkFetcher
    class << self
      def queue(link_id, user_id)
        ::GetLinkMetadata.perform_async(link_id, user_id)
      end
    end
  end

  class UrlExtractor
    class << self
      def extract(text)
        Twitter::Extractor.extract_urls_with_indices(text).first || {}
      end
    end
  end

  class UrlParser
    class << self
      def create(url)
        MetaInspector::URL.new(url).url
      end
    end
  end
end
