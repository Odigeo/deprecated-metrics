class InstancesController < ApplicationController

  ocean_resource_controller #required_attributes: [:lock_version, :name, :description]

  respond_to :json

  skip_before_filter :require_x_api_token, only: :refresh
  skip_before_filter :authorize_action, only: :refresh

  before_filter :find_instance, only: :show


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
  
  
  private
     
  def find_instance
    @instance = Instance.find_by_instance_id params[:id]
    return true if @instance
    render_api_error 404, "Instance not found"
    false
  end
    
end
