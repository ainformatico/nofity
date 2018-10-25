module MessagesHelper
  def map_message_classname(key)
    case key.to_sym
    when :notice then :info
    when :alert then :danger
    end
  end
end
