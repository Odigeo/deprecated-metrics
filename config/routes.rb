Metrics::Application.routes.draw do

  resources :rspecs

  resources :instances

  scope "v1" do
    
    resources :instances, only: [:index, :show]

  end

end
