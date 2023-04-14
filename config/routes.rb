# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'time_sheets#index'
  get 'profile', to: 'users#profile'
  patch 'profile', to: 'users#update_profile'
  get 'change_password', to: 'passwords#change_password'
  patch 'reset_password', to: 'passwords#reset_password'
  resources :time_sheets, only: %i[index create]
  resources :questions
  resources :leave_requests

  namespace :admin do
    resources :holidays
    resources :time_sheets
    resources :answers
    resources :departments
    resources :users
  end

  namespace :leader do
    resources :leave_requests, only: %i[index update]
  end

  namespace :api do
    namespace :v1 do
      resources :districts, only: [:index]
    end
  end
end
