Housekeeper::Application.routes.draw do
  resources :circles, except: [:destroy, :update]
  resources :users, only: [:index, :show]

  get '/user', to: 'users#show'
  patch '/user', to: 'users#update'
end
