# prefix all mails
class EmailPrefixer
  def self.delivering_email(message)
    message.subject = "[nofity] #{message.subject}"
  end
end

ActionMailer::Base.register_interceptor(EmailPrefixer)
