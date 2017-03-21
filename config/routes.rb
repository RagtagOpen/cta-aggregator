Rails.application.routes.draw do

  jsonapi_resources :events
  jsonapi_resources :locations
  jsonapi_resources :contacts

end
