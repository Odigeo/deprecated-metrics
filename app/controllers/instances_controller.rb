class InstancesController < ApplicationController

  ocean_resource_controller extra_actions: { 'start'      => ['start', "PUT"],
                                             'stop'       => ['stop', "PUT"],  
                                             'reboot'     => ['reboot', "PUT"],  
                                             'terminate'  => ['terminate', "DELETE"]  
                                           }

  respond_to :json

  skip_before_filter :require_x_api_token, only: :refresh
  skip_before_filter :authorize_action, only: :refresh

  before_filter :find_instance, except: [:index, :refresh]


  # GET /instances
  def index
    expires_in 0, 's-maxage' => 3.hours
    if stale?(collection_etag(Instance))
      api_render Instance.collection(params)
    end
  end


  # GET /instances/1
  def show
    expires_in 0, 's-maxage' => 3.hours
    if stale?(@instance)
      api_render @instance
    end
  end


  # PUT /instances/refresh
  def refresh
    Instance.refresh_all
    render text: ""
  end


  def start
    @instance.start("Started by the Ocean Metrics service")
    render text: ""
  end
  
  
  def stop
    @instance.stop
    render text: ""
  end
  
  
  def reboot
    @instance.reboot
    render text: ""
  end
  
  
  def terminate
    @instance.terminate
    render text: ""
  end
  
  
  private
     
  def find_instance
    @instance = Instance.find_by_instance_id params[:id]
    return true if @instance
    render_api_error 404, "Instance not found"
    false
  end
    
end
