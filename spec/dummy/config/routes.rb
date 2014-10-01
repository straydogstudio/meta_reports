Rails.application.routes.draw do
  resources :reports

  root to: "home#index"
end
