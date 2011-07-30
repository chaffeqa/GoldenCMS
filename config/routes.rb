GoldenCMS::Application.routes.draw do

  devise_for :administrators, :controllers => { 
    :registrations => "admin/administrators_registrations", 
    :sessions => "admin/administrators_sessions"
  }


  # Questions for 'Contact Us'
  resources :questions, :only => [:new, :create]


  # Admin Namespace
  namespace "admin" do
    #match ':shortcut/:page_area/new_element' => 'elements#new_element', :as => :new_element
    resource :sites
    resources :pages, :except => [:show] do 
      post :sort, :on => :collection
      resources :elements, :except => [:index] do
        post :move_up, :on => :member
        post :move_down, :on => :member
      end
    end
    resources :menus, :only => [:index] do
     post :sort, :on => :collection
    end
    resources :items
    resources :blogs, :except => [:show] do
      resources :posts, :except => [:index]
    end
    resources :categories, :except => [:show] do
      post :move_up, :on => :member
      post :move_down, :on => :member
    end
    resources :questions, :only => [:index, :show, :destroy]
    resources :calendars, :except => [:show] do
      resources :events, :except => [:index]
    end
#    scope :module => 'page_elems' do
#      resources :login_elems, :only => [:new]
#      resources :item_elems, :except => [:index, :show]
#      resources :item_list_elems, :except => [:index, :show]
#      resources :blog_elems, :except => [:index, :show]
#      resources :calendar_elems, :except => [:index, :show]
#      resources :text_elems, :except => [:index, :show]
#      resources :link_elems, :except => [:index] do
#        post :file, :on => :member
#      end
#      resources :image_elems, :except => [:index, :show]
#      resource :item_search_elems, :only => [:new]
#      resource :navigation_elems, :except => [:index, :show]
#    end
  end


  # TODO fix these routes to be made from the Node template_path
  match "error" => 'errors#error', :as => :error
  
  match ':shortcut(/:year(/:month))' => 'routing#by_shortcut', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  match ':shortcut' => 'routing#by_shortcut', :as => :shortcut, :constraints => { :shortcut => /[a-zA-Z0-9\-_]+/}, :formats => [:html, :js]

  root :to => 'routing#by_shortcut'
end
