class AnnouncementsController < ApplicationController

  def list
    #Array of announcements objects from db
    @announcement = Announcement.all
  end

  def new
    @announcement = Announcement.new
  end


  #Posts Announcement message to database
  def post_groupme
    bot_id="0362d66a5b301660702822ff24"
    url = "https://api.groupme.com/v3"

    #Creates an array of announcements objects
    all_announcements = Array.new

    #Stores entire db into variable for processing
    @announcements = Announcement.all

    #For each announcements
    @announcements.each do |an_entry|

      #Store database variables as ruby variables for easier understanding
      ann_title = an_entry.title
      ann_text = an_entry.announcementText
      ann_date = an_entry.date
      ann_time = an_entry.time

      #Create Text to post with based off announcements db columns
      if (ann_text == ' ') then
        text = ann_title + "\n" + ann_text + "\nOn: " + ann_date + "\nAt: " + ann_time
      end
      text = ann_title + "\n" + ann_text + "\nOn: " + ann_date + "\nAt: " + ann_time

      #Submit Post Request
      resp = Faraday.post('https://api.groupme.com/v3/bots/post') do |req|
        #Bot ID JSON header
        req.params['bot_id'] = bot_id

        #Actual Text header Header
        req.params['text'] = text

        #format of info being sent
        req.headers['Content-Type'] = 'application/json'
      end

      #output status of post to console
      puts resp.status
    end

    #redirect back to list page
    redirect_to :action => 'list'
  end


  def create
    @announcement = Announcement.new(announcement_params)

    if @announcement.save
      redirect_to :action => 'list'
    else
      @announcement = Announcement.all
      render :action => 'new'
    end

  end

  def announcement_params
    params.require(:announcement).permit(:announcementText, :date, :time, :title)
  end

  #deletes all entry in the database
  def delete_all
    Announcement.delete_all
    redirect_to :action => 'list'
  end

  #renders new post page
  def new_post
    render 'announcements/new_post'
  end

  #shows an object in the database
  def show
    @announcement = Announcement.find(params[:id])
  end

  #deletes an object from the database
  def delete
    @announcement = Announcement.delete(params[:id])
    redirect_to :action => 'list'
  end

  #creates post based off html form
  def create_post
    #Creates new announcements object
    insertion_val = Announcement.new
    #Allows for empty announcements text
    # if nothing is returned in the form
    # then add a value with just a space
    # this is to ensure that the db condition
    # of NOT NULL is satisfied
    if (params['announcements']["announcement"].length == 0) then
      insertion_val.announcementText= " "
    else
      #else its not empty, so add the announcements
      insertion_val.announcementText= params['announcements']['announcement']
    end

    insertion_val.title= params['announcements']['title']
    insertion_val.date= params['announcements']['date']
    insertion_val.time= params['announcements']['time']
    insertion_val.save

    #redirected to
    redirect_to :action => 'list'
  end

  def handle_webhook

    bot_id="0362d66a5b301660702822ff24"
    url = "https://api.groupme.com/v3"

    post_text = params[:text]

    case post_text
    when "/announce"
      #Checks if theres anything in announcements db
      if(Announcement.all.size == 0)
        text = "No announcements currently."
      else
        #if its not empty, redirect to content poster.
        redirect_to :action => 'post_groupme'
      end

    when "/info"
      text = "Created due to boredom"
    when "/face"
      text = "( ͡° ͜ʖ ͡°)"
    end

    #Submit Post Request
    resp = Faraday.post('https://api.groupme.com/v3/bots/post') do |req|
      #Bot ID JSON header
      req.params['bot_id'] = bot_id

      #Actual Text header Header
      req.params['text'] = text

      #format of info being sent
      req.headers['Content-Type'] = 'application/json'
    end

    #output status of post to console
    puts resp.status

  end

end
