MetaReports::Engine.routes.draw do
  root to: "reports#index"

  get 'reports/file/:dir' => 'reports#file'
  resources :reports
  get ':id(.:format)' => 'reports#show'
  get ':id/edit' => 'reports#edit'
  get 'form/:id' => 'reports#form'
end
