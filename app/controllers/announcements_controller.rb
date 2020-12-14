class AnnouncementsController < ApplicationController

  before_action #:set_time


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

  def disable_btn
    puts "Got here."

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

    #Title Simply added
    insertion_val.title= params['announcements']['title']

    #Replaces : with / for date
    insertion_val.date= "#{params['announcements']['date'][5,2]}/#{params['announcements']['date'][8,2]}"


    time = params['announcements']['time']

    #Gets hour portion of time
    hour_portion = time[0,2].to_i

    #Gets minute eportion of time
    minute_portion = time[3,2].to_i

    #Fixes time to not make it 24 hours lol(Murica)
    if(hour_portion > 12)
      hour_portion = hour_portion - 12
      day_clock = "#{hour_portion}:#{minute_portion}PM"
    elsif(hour_portion == 12)
      day_clock = "1:#{minute_portion}AM"

    else
      day_clock = "#{hour_portion}:#{minute_portion}AM"
    end

    insertion_val.time=day_clock
    insertion_val.save

    #redirected to list page of all announcements
    redirect_to :action => 'list'
  end


  def handle_webhook

    puts("Text")

    bot_id="0362d66a5b301660702822ff24"
    url = "https://api.groupme.com/v3"

    post_text = params[:text]

    shouldPost = true

    case post_text

    when "/announce"
      #Checks if theres anything in announcements db
      if(Announcement.all.size == 0)
        text = "No announcements currently."
      else
        #if its not empty, redirect to content poster.
        #
        if( Time.now.to_i - Rails.configuration.x.start_time> 30 || Rails.configuration.x.hasnt_posted_even_once)

          Rails.configuration.x.start_time = Time.now.to_f
          redirect_to :action => 'post_groupme'
          Rails.configuration.x.hasSpoken = false
          Rails.configuration.x.hasnt_posted_even_once = false
          shouldPost = false
        elsif (Time.now.to_i - Rails.configuration.x.start_time < 30 && !Rails.configuration.x.hasSpoken)
          text = "On 30 minute timedown."
          Rails.configuration.x.hasSpoken = true
        else
          shouldPost = false
        end
        # TODO: Check If the command was used recently,
        #
        # TODO: If So, alert once saying error
        #
        # TODO: Next Time, don't alert



      end

    when "/info"
      text = "GORTS baby"
    when "/face"
      text = "( ͡° ͜ʖ ͡°)"
    when "/deepquote"
      text = "As Above, So Below."
    when "/debug"
      #text = "Elapsed Time Since Initialization: #{Time.now.to_f - Rails.configuration.x.t1} "
      text = "Time since last /announce call: #{Time.now.to_i - Rails.configuration.x.start_time}"
      #Case for when user tries to

    end

    if(shouldPost)
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

  # private
  # def set_time
  #
  #   if(!Rails.configuration.x.toggle)
  #     Rails.configuration.x.start_time = Time.now.to_f
  #     Rails.configuration.x.toggle = true
  #   end
  # end

end
