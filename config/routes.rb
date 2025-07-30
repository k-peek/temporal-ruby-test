Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Bob's Game Store Temporal Demos
  scope :bobs_game_store do
    get "/", to: "bobs_game_store#index"
    post :simple_purchase, to: "bobs_game_store#simple_purchase"
    post :order_cancellation, to: "bobs_game_store#order_cancellation"
    post :preorder, to: "bobs_game_store#preorder"
    get "workflow/:workflow_id", to: "bobs_game_store#workflow_status"
  end

  # Defines the root path route ("/")
  root "bobs_game_store#index"
end
