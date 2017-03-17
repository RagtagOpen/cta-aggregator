Rails.application.routes.draw do

  jsonapi_resources :call_to_actions
  jsonapi_resources :locations
  jsonapi_resources :contacts

end
