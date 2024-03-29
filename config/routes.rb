# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users, skip: [:registrations]
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root to: 'time_sheets#index'
    mount ActionCable.server => '/cable'
    get 'profile', to: 'users#profile'
    patch 'profile', to: 'users#update_profile'
    get 'settings', to: 'settings#index'
    patch 'settings/reset_password', to: 'settings#reset_password'
    patch 'settings/reset_preferred_locale', to: 'settings#reset_preferred_locale'
    resources :time_sheets, only: %i[index create update]
    resources :questions
    resources :leave_requests
    get 'csvs/export', to: 'csvs#export', defaults: { format: :csv }
    resources :room_pickers
    resources :room_pickers, only: %i[index]
    resources :notifications, only: %i[index show]

    namespace :admin do
      resources :holidays
      # resources :time_sheets
      get 'time_sheets', to: 'time_sheets#summary'
      get 'time_sheet/users', to: 'time_sheets#users'
      get 'answers', to: 'answers#summary'
      resources :questions do
        resources :answers
      end
      resources :departments
      resources :user_departments
      patch :update_multi_user_department, to: 'user_departments#update_multi'
      resources :users do
        resources :contracts
        patch "/contracts/:id/inactive_status", to: 'contracts#inactive_status'
        resources :time_sheets
        resources :user_leave_times
      end
      post 'send_time_sheet_mail', to: 'time_sheets#send_time_sheet_mail'
      resources :rooms
    end

    namespace :leader do
      resources :leave_requests, only: %i[index update show]
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
        get 'repeat_room_pickers', to: 'room_pickers#repeat'
        resources :holidays, only: [:index, :create, :update, :destroy]

        namespace :admin do
          resources :users, only: [:index]
          post 'time_sheets/check_import_data', to: 'time_sheets#check_import_data'
          get 'user_departments/not_have_department', to: 'user_departments#not_have_department'
        end
      end
    end
  end
end
