Metrics::Application.routes.draw do


  scope "v1" do
    
    resources :instances, only: [:index, :show], constraints: {id: /.+/} do

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

  end

end
