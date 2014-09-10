# These are set by the config/aws_config.rb initializer in ocean-rails
Aws.config[:region] = ENV['AWS_REGION']
Aws.config[:access_key_id] = ENV['AWS_ACCESS_KEY_ID']
Aws.config[:secret_access_key] = ENV['AWS_SECRET_ACCESS_KEY']

# Instances
$ec2 = Aws::EC2::Client.new

# DynamoTables
$dynamo = Aws::DynamoDB::Client.new 
