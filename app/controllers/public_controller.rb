class PublicController < ApplicationController
  skip_before_filter :authenticate_user!

  layout 'public'

  def tos
    render 'tos'
  end

  def privacy_policy
    render 'privacy_policy'
  end

  def bot
    render 'bot'
  end
end
