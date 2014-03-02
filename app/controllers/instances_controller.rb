class InstancesController < ApplicationController

  ocean_resource_controller #required_attributes: [:lock_version, :name, :description]

  respond_to :json
  
  before_action :find_instance, only: :show
    
  
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
  
  
  private
     
  def find_instance
    @instance = Instance.find_by_instance_id params[:id]
    return true if @instance
    render_api_error 404, "Instance not found"
    false
  end
    
end
