MetaReports::Engine.routes.draw do
  root to: "reports#index"

  get 'reports/file/:dir' => 'reports#file', as: 'file'
  get 'new' => 'reports#new', as: 'short_new'
  post 'reports' => 'reports#create', as: 'normal_create'
  match ':id(.:format)' => 'reports#show', as: 'short_show', via: [:get, :post]
  get ':id/edit' => 'reports#edit', as: 'short_edit'
  get ':id/form' => 'reports#form', as: 'short_form'
  resources :reports
end
