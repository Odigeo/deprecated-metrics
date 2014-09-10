class DynamoTable

  def self.delete_test_tables(chef_env)
    obtain_all_dynamodb_tables.each do |table_name|
      delete_table(table_name) if purgeable?(table_name, chef_env)
    end
  end

  def self.obtain_all_dynamodb_tables
  	# Add paging here - more than one request may be necessary to get items 100+ etc
    $dynamo.list_tables.table_names
  end

  def self.purgeable?(table_name, chef_env)
  	chef_env = "(master|dev)" if chef_env == "master"
  	!!(table_name =~ Regexp.new("^.+_#{chef_env}_[0-9]{1,3}-[0-9]{1,3}-[0-9]{1,3}-[0-9]{1,3}_test$"))
  end

  def self.delete_table(table_name)
    Rails.logger.info "Deleting DynamoDB table #{table_name}"
    begin
  	  $dynamo.delete_table(table_name: table_name)
    rescue Aws::DynamoDB::Errors::LimitExceededException
      Rails.logger.debug "AWS deletion failed due to deletion limit reached, waiting and retrying..."
      sleep 10
      retry
    end
  end

end
