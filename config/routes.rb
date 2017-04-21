Rails.application.routes.draw do

  namespace :v1, defaults: { format: 'json' } do
    post 'authorize' => 'user_token#create'
    jsonapi_resources :ctas
    jsonapi_resources :locations
    jsonapi_resources :contacts
    jsonapi_resources :call_scripts
  end

  root to: 'welcome#index'
end
