Rails.application.routes.draw do
  root to: "messages#new"

  resources :messages, path: :m, only: [:new, :create, :show]

  get '/faq', controller: :static_pages, action: :faq
  get '/:id', controller: :messages, action: :show
end

