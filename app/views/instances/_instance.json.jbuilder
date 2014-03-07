json.instance do |json|
  if instance.state == "stopped"
	  json._links       hyperlinks(self:      instance_url(id: instance.instance_id),
                                 start:     start_instance_url(id: instance.instance_id),
                                 terminate: terminate_instance_url(id: instance.instance_id))
  elsif instance.state == "running"
    json._links       hyperlinks(self:      instance_url(id: instance.instance_id),
                                 stop:      stop_instance_url(id: instance.instance_id),
                                 reboot:    reboot_instance_url(id: instance.instance_id))
  else
    json._links       hyperlinks(self:      instance_url(id: instance.instance_id))
  end
	json.(instance,   :instance_id, 
                    :name, :description, :chef_env, :service, :subservice,
                    :state, :instance_type, :availability_zone, :subnet_id,
                    :private_ip_address)
  json.launch_time  instance.launch_time.utc.iso8601 if instance.launch_time
	json.created_at   instance.created_at.utc.iso8601
	json.updated_at   instance.updated_at.utc.iso8601
  json.lock_version instance.lock_version
end
