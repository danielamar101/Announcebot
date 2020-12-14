class KeyController < ApplicationController

  #Goes to form
  def invite_create
    @key = Key.all
  end

  #Actually creates key
  def create

    #Grabs inputted key
    new_key = params['key']['key']

    @key = Key.create!(key: new_key)


    #TODO: Make this go back to base page, not home
    redirect_to root_url
  end


  #Deletes button
  def delete
    @key = Key.delete(params[:id])
    redirect_to :action => 'invite_create'
  end
end
