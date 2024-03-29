Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        post 'sign_up', to: 'registrations#create'
        post 'sign_in', to: 'sessions#create'
      end

      resources :projects do
        get :tasks, to: 'projects#related_tasks', on: :member
      end
      resources :tasks, except: :index
    end
  end
end
