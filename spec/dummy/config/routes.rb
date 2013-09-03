Rails.application.routes.draw do
  mount MetaReports::Engine => "/meta_reports"
  root to: "home#index"
end
