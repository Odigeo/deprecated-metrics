class DynamoTablesController < ApplicationController

  ocean_resource_controller extra_actions: { 'delete_test_tables' => ['delete_test_tables', "PUT"]  
                                           }

  respond_to :json

  before_filter :find_instance, except: [:index, :delete_test_tables]


  # GET /dynamo_tables
  def index
    expires_in 0, 's-maxage' => 3.hours
    if stale?(collection_etag(DynamoTable))
      api_render DynamoTable.collection(params)
    end
  end


  # POST /dynamo_tables
  def create
  end


  # GET /dynamo_tables/1
  def show
    expires_in 0, 's-maxage' => 3.hours
    if stale?(@dynamo_table)
      api_render @dynamo_table
    end
  end


  # PUT /dynamo_tables/1
  def update
  end


  # DELETE /dynamo_tables/1
  def destroy
  end


  # PUT /dynamo_tables/delete_test_tables
  def delete_test_tables
    DynamoTable.delete_test_tables
    render_head_204
  end
  
  
  private
     
  def find_dynamo_table
    @dynamo_table = DynamoTable.find_by_instance_id params[:id]
    return true if @dynamo_table
    render_api_error 404, "DynamoTable not found"
    false
  end
    
end
