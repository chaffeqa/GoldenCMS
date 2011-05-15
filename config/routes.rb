GoldenCMS::Application.routes.draw do

  devise_for :admins

  resources :elements, :only => [:destroy] do
    post :move_up, :on => :member
    post :move_down, :on => :member
  end

  # Questions for 'Contact Us'
  resources :questions, :only => [:new, :create]


  # Admin Namespace
  namespace "admin" do
    resource :sites
    resources :dynamic_pages, :except => [:show]
    resources :menus, :only => [:index] do
      post :sort, :on => :collection
    end
    resources :items do
      # Managing Regulations
      get :manage_regulations, :on => :collection
      post :manage_regulations, :on => :collection
      delete :manage_regulations, :on => :collection
      # Managing Capabilities
      get :manage_capabilities, :on => :collection
      post :manage_capabilities, :on => :collection
      delete :manage_capabilities, :on => :collection
    end
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
    scope :module => 'page_elems' do
      resources :login_elems, :only => [:new]
      resources :item_elems, :except => [:index, :show]
      resources :item_list_elems, :except => [:index, :show]
      resources :blog_elems, :except => [:index, :show]
      resources :calendar_elems, :except => [:index, :show]
      resources :text_elems, :except => [:index, :show]
      resources :link_elems, :except => [:index] do
        post :file, :on => :member
      end
      resources :image_elems, :except => [:index, :show]
      resource :item_search_elems, :only => [:new]
      resource :side_nav_elems, :only => [:new, :destroy]
    end
  end



  match 'inventory' => 'inventory#inventory', :as => :inventory
  get 'inventory/search', :as => :inventory_search
  match 'items' => 'inventory#search' # Since we don't want to allow /items to call item#show
  match "error" => 'shortcut#error', :as => :error
  match ':shortcut(/:year(/:month))' => 'shortcut#route', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}
  match ':shortcut/:page_area/new_element' => 'dynamic_pages#new_element', :as => :new_element
  match ':shortcut(.:format)' => 'shortcut#route', :as => :shortcut, :constraints => { :shortcut => /[a-zA-Z0-9\-_]+/}, :formats => [:html, :js]

  #constraints(Subdomain) do
  #  match '/' => 'shortcut#home' # TODO change back to sites#show
  #end

  #  match '/admin/:controller/:action(/:id)'
  #  match '/:controller/:action(/:id)'

  root :to => 'shortcut#home'
end
