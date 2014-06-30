Housekeeper::Application.routes.draw do
  resources :circles, except: [:destroy, :update]
  resources :users, only: :show

  get '/user', to: 'users#show'
end
