Rails.application.routes.draw do

  namespace :v1, defaults: { format: 'json' } do
    post 'authentications' => 'user_token#create'
    jsonapi_resources :advocacy_campaigns
    jsonapi_resources :targets
    jsonapi_resources :events
    jsonapi_resources :locations
  end

  root to: 'welcome#index'
end
