Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :projects do
        get :tasks, to: 'projects#related_tasks', on: :member
      end

      resources :tasks, except: :index
    end
  end
end
