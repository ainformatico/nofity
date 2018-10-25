class ApplicationController < ActionController::Base
  include OnboardingHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_user!, except: :sitemap

  rescue_from ActionController::ParameterMissing, with: :control_bad_request

  layout :layout_by_resource

  def control_bad_request(parameter_missing_exception)
    error = {}
    error[parameter_missing_exception.param] = ['parameter is required']
    response = { errors: [error] }
    respond_to do |format|
      format.json { render json: response, status: :bad_request }
    end
  end

  def sitemap
    path = Rails.root.join('public', 'sitemaps', 'sitemap.xml')

    if File.exist?(path)
      render xml: open(path).read
    else
      render text: 'Sitemap not found.', status: :not_found
    end
  end

  protected

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      # do not set gon data when json requests
      config_data unless json_request?
      'application'
    end
  end

  def config_data
    gon.is_dev = Rails.env == 'development'
    gon.uid = current_user.idsec
    gon.i18n = {
      onboardings: {
        initial: onboarding_i18n(:initial, 4)
      }
    }
    gon.features = {
      categories: Featurer.on?(:categories, current_user.id)
    }
    gon.onboardings = { # show?
      initial: !Featurer.on?(onboarding_name('initial'), current_user.id)
    }
  end

  def json_request?
    request.format.to_s =~ /json\z/
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  private

  def onboarding_i18n(name, number_steps)
    (1..number_steps).map do |i|
      {
        title: I18n.t("onboardings.#{name}.step#{i}.title"),
        content: I18n.t("onboardings.#{name}.step#{i}.content")
      }
    end
  end

  def render_layout(layout_name, status)
    if user_signed_in?
      render 'layouts/application' unless json_request?
    else
      render layout: layout_name, status: (status ? :ok : :not_found)
    end
  end
end
