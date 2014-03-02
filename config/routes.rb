Metrics::Application.routes.draw do

  scope "v1" do
    
    resources :instances, only: [:index, :show], constraints: {id: /.+/}

  end

end
