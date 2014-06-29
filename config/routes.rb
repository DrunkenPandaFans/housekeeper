Housekeeper::Application.routes.draw do
  resources :circles, except: [:destroy, :update]
end
