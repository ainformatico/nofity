domain = 'nofity.com'
host domain

class UrlParser
  attr_reader :root

  def initialize(base)
    create_base(base)
  end

  def create_base(base)
    @base = base.sub!(/\/$/, '')
    @root = convert_ssl(base)
  end

  def convert_ssl(url)
    url.sub(/^http/, 'https')
  end

  def generate_url(path)
    "#{@root}#{path}"
  end

  def convert_idsec(base_path, idsec)
    convert_ssl("#{base_path.sub(/\d+$/, '')}#{idsec}")
  end
end

sitemap :site do
  props = { last_mod: Time.now, change_freq: 'daily', priority: 1.0 }
  parser = UrlParser.new(root_url)
  url parser.root, props

  url parser.generate_url(bot_path).to_s, props.merge(priority: 0.7, change_freq: 'weekly')
  url parser.generate_url(privacy_policy_path).to_s, props.merge(priority: 0.7, change_freq: 'weekly')
  url parser.generate_url(tos_path).to_s, props.merge(priority: 0.7, change_freq: 'weekly')
  url parser.generate_url(new_user_session_path).to_s, props.merge(priority: 0.7, change_freq: 'weekly')
  url parser.generate_url(invitation_request_path).to_s, props.merge(priority: 0.8, change_freq: 'weekly')
  url parser.generate_url(support_index_path).to_s, props.merge(priority: 0.8, change_freq: 'weekly')
  url parser.generate_url(public_notes_path).to_s, props.merge(priority: 0.8, change_freq: 'weekly')
end

sitemap_for Note.all_public, name: :notes do |note|
  parser = UrlParser.new(root_url)
  note_url = parser.convert_idsec(format_url(note), note.idsec).to_s
  url note_url, last_mod: note.updated_at, priority: 1.0
end
