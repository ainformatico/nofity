class UserController < ApplicationController
  respond_to :json

  before_action :filter_requests
  before_action :ensure_user

  def index; end

  private

  def ensure_user
    @user = current_user
  end

  def filter_requests
    redirect_to root_path unless json_request?
  end
end
