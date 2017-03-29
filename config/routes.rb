Rails.application.routes.draw do

  namespace :v1, defaults: { format: 'json' } do
    jsonapi_resources :events
    jsonapi_resources :locations
    jsonapi_resources :contacts
    jsonapi_resources :call_scripts
  end

  root to: 'welcome#index'
end
