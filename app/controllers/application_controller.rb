require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html
  before_action :enable_profiler

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"

    throw exception if Rails.env.development?
    if user_signed_in? && current_user.fresh?
      redirect_to sign_up_complete_path
    else
      redirect_to new_session_path
    end
  end

  private

  def enable_profiler
    if current_user&.admin? &&
        Rails.configuration.respond_to?(:load_mini_profiler) &&
        Rails.configuration.load_mini_profiler
      Rack::MiniProfiler.authorize_request
    end
  end
end
