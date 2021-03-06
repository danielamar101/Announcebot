module ApplicationHelper

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
    if(current_user)
    @current_user.isAdmin ||= User.find_by(id: session[:user_id]).isAdmin
    end
  end



end
