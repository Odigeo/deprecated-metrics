json.instance do |json|
	json._links       hyperlinks(self:    instance_url(instance))
	json.(instance,   :instance_id, 
                    :name, 
                    :description,
                    :chef_env,
                    :service,
                    :subservice,
                    :contents) 
	json.created_at   instance.created_at.utc.iso8601
	json.updated_at   instance.updated_at.utc.iso8601
  json.lock_version instance.lock_version
end
