Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  #
  # Defines the root path route ("/")
  # root "articles#index"

  scope "api" do
    post "login", to: "sessions#create"
    get "user", to: "sessions#user"

    resources :users, only: %i[index create update destroy]
    resources :roles, only: %i[index create update destroy]
    resources :permissions, only: %i[index]
  end
end
