class SessionController < ApplicationController


  def create

    #Find user then
    # check and see if the password that the user
    # supplies matches the encrypted one that is stored
    # in the database.
    user = User.find_by(username: params['session']["username"])
               .try(:authenticate, params['session']["password"])

    #If user is not nil(first check passed) then...
    if user
      log_in user
      redirect_to :controller => 'application', :action => 'home'

      #redirect_to :controller => 'sessions', :action => 'home'
    else
      render json: { status: 401 }
    end
  end

  def destroy
    session[:user_id] =  nil
    redirect_to root_url
  end

  #redirects to login page
  def login
  end

  def goto_signup
  end
end
