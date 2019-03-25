Rails.application.routes.draw do
  root to: 'frontend#show'
  resources :visits, only: %i(index)
end
