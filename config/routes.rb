Metrics::Application.routes.draw do

  # The following is outside the version scope, so as not to be
  # accessible from the outside.
  put "instances/refresh", to: "instances#refresh"


  scope "v1" do
    
    resources :instances, only: [:index, :show], constraints: {id: /.+/}

  end

end
