MetaReports::Engine.routes.draw do
  root to: "reports#index"

  get 'reports/file/:dir' => 'reports#file', as: 'file'
  resources :reports
  match ':id(.:format)' => 'reports#show', as: 'short_show'
  get ':id/edit' => 'reports#edit', as: 'short_edit'
  get ':id/form' => 'reports#form', as: 'short_form'
end
