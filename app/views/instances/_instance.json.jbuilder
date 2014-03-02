json.instance do |json|
	json._links       hyperlinks(self:    instance_url(instance))
	json.(instance, :lock_version, :name, :description) 
	json.created_at   instance.created_at.utc.iso8601
	json.updated_at   instance.updated_at.utc.iso8601
end
