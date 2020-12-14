class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def home
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out(user)
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def access_tools
    @current_user.isAdmin ||= User.find_by(id: session[:user_id]).isAdmin?
  end
end
