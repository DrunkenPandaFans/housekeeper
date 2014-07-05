Housekeeper::Application.routes.draw do

  namespace :api, path: '/',  constraint: { subdomain: 'api' } do
    resources :circles, except: [:new, :edit]
    resources :users, only: [:index, :show]

    get '/user', to: 'users#show'
    patch '/user', to: 'users#update'
  end

end
