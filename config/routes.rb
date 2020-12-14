Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root 'application#home'


  class OnlyAjaxRequest
    def matches?(request)
      request.xhr?
    end
  end

  get '/new_post' => 'announcements#new_post'
  get 'announcements/new'
  get 'announcements/list'
  get 'announcements/show'
  post 'announcements/create'
  get 'announcements/new_post'
  get 'announcements/delete_all'
  get 'announcements/delete'
  get 'announcements/disable_btn', to:'announcements#disable_btn', constraints: OnlyAjaxRequest.new

  #Takes you to key making page
  get '/key/invite_create', to: 'key#invite_create', as: 'key_form'
  #Actually creates the key and stores into db
  post 'key/create', to: 'key#create', as: 'key_create'

  get 'key/key_list', to: 'keys#list', as: 'key_list'

  #Delete key path
  get 'key/delete'



  #Redirects webhook post to handle webhook method
  post 'announcements/handle_group_post', to: 'announcements#handle_webhook'

  resources :session, only: [:create]

  resources :announcements do

    #for each announcements
    collection do
      #redirect info to post_groupme controller method
      get :post_groupme
    end
  end

  post '/create_post', :to => 'announcements#create_post', as: 'create_post'

  post 'session', to: 'session#create', as: 'session'


  #Redirect to login page when button is clicked via method that renders page
  get 'login', to: 'session#login', as: 'login'

  get '/signup', to: 'register#signup', as: 'signup'
  post '/try_signup' => 'register#create', as: 'try_signup'

  #Go to index page after login
  get 'index', to: 'announcements#list', as: 'index'

  #Logout Route
  get 'logout', to: 'session#destroy', as: 'logout'




end
