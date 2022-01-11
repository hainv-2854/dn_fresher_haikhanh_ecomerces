Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :products, only: %i(index show)
    namespace :admin do
      root "static_pages#home"
      get "/home", to: "static_pages#home"
      delete "/logout", to: "static_pages#destroy"
      resources :products
    end
  end
end
