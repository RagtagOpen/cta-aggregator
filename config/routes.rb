Rails.application.routes.draw do
  resources :call_to_actions, only: [:new, :create] 

end
