Metrics::Application.routes.draw do


  scope "v1" do
    
    resources :instances, only: [:index, :show], 
              constraints: {id: /.+/} do

      collection do
        put    "refresh"
      end
      
      member do
        put    "start"
        put    "stop"
        put    "reboot"
        delete "terminate"
      end
    end

    resources :dynamo_tables, only: [:index, :create, :show, :update, :destroy],
              constraints: {id: /.+/} do
      collection do
        put    "delete_test_tables"
      end
    end

  end

end
