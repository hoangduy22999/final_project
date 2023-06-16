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
  get 'csvs/export', to: 'csvs#export', defaults: { format: :csv }
  resources :room_pickers
  resources :chats, only: %i[index]
  resources :room_pickers, only: %i[index]
  mount ActionCable.server => '/cable'

  namespace :admin do
    resources :holidays
    resources :time_sheets
    resources :answers
    resources :departments
    resources :users
    resources :rooms
  end

  namespace :leader do
    resources :leave_requests, only: %i[index update]
    patch :update_multi_requests, to: 'leave_requests#update_multi'
  end

  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post "sign_in", to:  'sessions#create'
        delete "sign_out", to: 'sessions#destroy'
      end
      resources :districts, only: [:index]
      resources :cities, only: [:index]
      resources :leave_requests, only: [:index, :create, :update, :destroy]
      resources :time_sheets, only: [:index, :create]
      get 'leaders', to: 'users#leaders'
      resources :room_pickers, only: [:index, :create, :update, :destroy]
      resources :holidays, only: [:index, :create, :update, :destroy]
    end
  end
end
