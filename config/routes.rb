Rails.application.routes.draw do

  namespace :v1, defaults: { format: 'json' } do
    jsonapi_resources :events
    jsonapi_resources :locations
    jsonapi_resources :contacts
  end

  root to: 'welcome#index'
end
