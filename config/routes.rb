Rails.application.routes.draw do
  
  #route for the versions table
  post "versions/:id/revert" => "versions#revert", as: "revert_version"
  
  #nicely renamed for user experience improvements
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  
  
  resources :users
  resources :sessions
	resources :materials do 
	  collection { post :import }
	end
	root :to => 'materials#index'

end
