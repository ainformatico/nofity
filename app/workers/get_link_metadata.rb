class GetLinkMetadata
  include Sidekiq::Worker

  USER_AGENT = 'Nofitybot/0.1 (+https://nofity.com/bot)'.freeze

  def perform(link_id, user_id)
    @link = Link.find(link_id)
    @user = User.find(user_id)
    extract_metadata
  end

  def extract_metadata
    save_link_data(extract_link_metadata)
  # connection reset, timeout, redirection loop
  rescue Errno::ECONNRESET, Timeout::Error, RuntimeError
    save_raw
  # known errors: OpenURI::HTTPError, SocketError, Faraday::ConnectionFailed
  # for all of them assume not found
  rescue StandardError
    save_not_found
  end

  private

  def save_link_data(data)
    @link.url = data[:url]
    @link.title = data[:title]
    @link.description = data[:description]
    @link.processed = true
    @link.save
  end

  def save_raw
    @link.update_attributes(title: @link.url, description: @link.url, processed: true)
  end

  def save_not_found
    @link.update_attributes(
      title: I18n.t('note.link.not_found'),
      description: @link.url,
      processed: true,
      not_found: true
    )
  end

  def extract_link_metadata
    page = MetaInspector.new(@link.url, default_params)
    description = parse_description(page)
    title = parse_title(page)

    {
      url:   page.url,
      title: title,
      description: description
    }
  end

  def default_params
    {
      allow_redirections: true,
      headers: {
        'User-Agent' => USER_AGENT
      }
    }
  end

  def parse_title(page)
    if page.title.nil? || page.title.empty?
      page.url
    else
      page.title
    end
  end

  def parse_description(page)
    page.meta['description'] || select_custom_description(page.parsed)
  end

  def select_custom_description(nokogiri)
    item = nokogiri.css('meta[itemprop="description"]')
    item.attr('content').value unless item.empty?
  end
end
