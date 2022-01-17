Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :carts, except: %i(show new edit) do
      collection do
        get "delete-all", to: "carts#destroy_all"
      end
    end

    resources :products, only: %i(index show)
    namespace :admin do
      root "static_pages#home"
      get "/home", to: "static_pages#home"
      delete "/logout", to: "static_pages#destroy"
      resources :products
      resources :users
      scope :orders do
        resource :bulk_order
      end
      resources :orders do
        resources :order_details, only: :index
      end
    end
  end
end
