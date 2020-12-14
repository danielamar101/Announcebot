class RegisterController < ApplicationController

  def home
  end

  def create


    #Determines if user got key from admin or not
    valid_key = Key.find_by(key: params['register']["invite_key"])


    if valid_key
      puts "Invitation Key Is Valid"
      #creates user and automatically encrypts
      user = User.create!(
          username: params['register']['username'],
          password: params['register']['password'],
          password_confirmation: params['register']['password_confirmation'],
          isAdmin: false
      )
    else
      #Error, invite key invalid
      render json: { status: 500,codeMatched: 'False' }
    end

    if user
      puts "Passwords didn't match. Session ID not saved."
      session[:user_id] = user.id
      redirect_to :action => 'home', :controller => 'application'
    else
      #Error, pwords didnt match
      #render json: { status: 500  }
    end
  end

  #redirects to login page
  def login
  end

  def signup
  end
end
