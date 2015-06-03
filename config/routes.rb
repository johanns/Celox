# == Route Map
#
#      Prefix Verb URI Pattern      Controller#Action
#        root GET  /                messages#new
#    messages POST /m(.:format)     messages#create
# new_message GET  /m/new(.:format) messages#new
#     message GET  /m/:id(.:format) messages#show
#         faq GET  /faq(.:format)   static_pages#faq
#             GET  /:id(.:format)   messages#show
#

Rails.application.routes.draw do
  root to: "messages#new"

  resources :messages, path: :m, only: [:new, :create, :show]

  get '/faq', controller: :static_pages, action: :faq
  get '/:id', controller: :messages, action: :show
end

