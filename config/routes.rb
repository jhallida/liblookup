Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepage#index'

  get 'homepage/index'

  resources :homepage do
    collection do
      get 'downloadaction'
    end
  end

end
