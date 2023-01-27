# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations] 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static_page#home'
  get 'profile', to: 'users#profile'
  resources :users
  resources :departments

  namespace :api do
    namespace :v1 do
      resources :districts, only: [:index]
    end
  end 
end
