Rails.application.routes.draw do
	resources :materials do 
	  collection { post :import }
	end
	root :to => 'materials#index'

end
