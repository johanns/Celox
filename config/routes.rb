Celox::Application.routes.draw do
  if Rails.env == 'development' 
    devise_for :users
    mount RailsAdmin::Engine => "/admin"
  end

  # Note: Preserve the following root, get, post, and match order.
  controller :messages do           
    root :to => :new        
    get "/n", :to => :new
    post "/n", :to => :create, :as =>  :messages
    match "/:stub", :to => :show_by_stub, :as => :stub
  end

  # resources :messages, :only => [:new, :create] do
  #   root :to => "messages#new",  :via => [:get, :post]
  #   match '/:stub' => :show_by_stub, :as => :stub
  # end
end
