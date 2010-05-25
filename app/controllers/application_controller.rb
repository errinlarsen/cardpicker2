# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  has_mobile_fu false

  # iPhone user-agent string:
  # 

  # Capture CanCan access problems
  rescue_from CanCan::AccessDenied do |exception|
      flash[:alert] = "Access Denied"
      redirect_to root_path
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
