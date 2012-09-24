Celox::Application.routes.draw do
  # Note: Preserve the following root, get, post, and match order.
  controller :messages do           
    root :to => :new        
    get "/n", :to => :new
    post "/n", :to => :create, :as =>  :messages
    match "/:stub", :to => :show_by_stub, :as => :stub
  end
  
  # root :to => "messages#new"  
  # resources :messages, :path => :m, :only => [:new, :create], :via => [:get, :post]
  # match ':stub' => "messages#show_by_stub", :as => :stub, :via => [:get]
end
