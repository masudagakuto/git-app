Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'posts#index'

  get 'cad_analyzer', to: 'cad_analyzer#index'
  get 'cad_analyzer/health_check', to: 'cad_analyzer#health_check'
  post 'cad_analyzer/analyze', to: 'cad_analyzer#analyze'
end