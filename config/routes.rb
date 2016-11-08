Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :daily_log, only: [:new, :create]
  get "daily_log/report", to: "daily_log#report"
end
