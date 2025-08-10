Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Kevin's Store Temporal Demos
  scope :kevins_store do
    get "/", to: "kevins_store#index"
    post :simple_purchase, to: "kevins_store#simple_purchase"
    post :order_cancellation, to: "kevins_store#order_cancellation"
    get "result/:workflow_id", to: "kevins_store#result"
    get "workflow/:workflow_id", to: "kevins_store#workflow_status"
  end

  # Defines the root path route ("/")
  root "kevins_store#index"
end
