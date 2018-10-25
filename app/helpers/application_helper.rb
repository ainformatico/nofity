module ApplicationHelper
  def cache_name(name)
    "#{name}_#{APP.git_hash}"
  end

  def content_for_title
    output = if content_for? :title
               (content_for :title).to_s
             else
               t('home.title.slogan')
             end
    "#{APP.app_name} - #{output}"
  end

  def print_content_for(name, default)
    if content_for? name
      content_for name
    else
      default
    end
  end
end
