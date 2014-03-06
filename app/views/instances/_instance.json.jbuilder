json.instance do |json|
	json._links       hyperlinks(self:    instance_url(id: instance.instance_id))
	json.(instance,   :instance_id, 
                    :name, :description, :chef_env, :service, :subservice, :contents,
                    :state, :instance_type, :availability_zone, :subnet_id,
                    :private_ip_address)
    json.launch_time  instance.launch_time.utc.iso8601 if instance.launch_time
	json.created_at   instance.created_at.utc.iso8601
	json.updated_at   instance.updated_at.utc.iso8601
  json.lock_version instance.lock_version
end
