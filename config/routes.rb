Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' => 'budgets#landing'
  resources :budgets
  #      Prefix Verb   URI Pattern                 Controller#Action
  #     budgets GET    /budgets(.:format)          budgets#index
  #             POST   /budgets(.:format)          budgets#create
  #  new_budget GET    /budgets/new(.:format)      budgets#new
  # edit_budget GET    /budgets/:id/edit(.:format) budgets#edit
  #      budget GET    /budgets/:id(.:format)      budgets#show
  #             PATCH  /budgets/:id(.:format)      budgets#update
  #             PUT    /budgets/:id(.:format)      budgets#update
  #             DELETE /budgets/:id(.:format)      budgets#destroy

  resources :users
  # users GET    /users(.:format)            users#index
  #             POST   /users(.:format)            users#create
  #    new_user GET    /users/new(.:format)        users#new
  #   edit_user GET    /users/:id/edit(.:format)   users#edit
  #        user GET    /users/:id(.:format)        users#show
  #             PATCH  /users/:id(.:format)        users#update
  #             PUT    /users/:id(.:format)        users#update
  #             DELETE /users/:id(.:format)        users#destroy

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end
