class SupportController < ApplicationController
  skip_before_filter :authenticate_user!

  layout 'support'

  def index
    @support = Support.new
    @email = if user_signed_in?
               current_user.email
             else
               @support.email
             end
  end

  def create
    @support = create_support(support_params)
    if @support.save
      render action: :show
    else
      render action: :create
    end
  end

  private

  def create_support(options = {})
    Support.new(options)
  end

  def support_params
    params.require(:support).permit(:email, :content)
  end
end
