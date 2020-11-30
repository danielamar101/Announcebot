class RegisterController < ApplicationController

  def home
  end

  def create
    #creates user and automatically encrypts
    user = User.create!(
        username: params['username'],
        password: params['password'],
        password_confirmation: params['password_confirmation']
    )

    if user
      session[:user_id] = user.id
      puts "SessionController ID Num: #{user.id}"
      redirect_to :action => 'home', :controller => 'application'
    else
      #Error, pwords didnt match
      render json: { status: 500 }
    end
  end

  #redirects to login page
  def login
  end

  def signup
  end
end
