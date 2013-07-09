
# add/update groups
node['accounting']['groups'].each do |g|
  if node["etc"]["group"].has_key? g['name']
    group g['name'] do
      gid g['gid'] || nil
      system g['system'] || nil
      members g['members']
      action :modify
    end
  else
    group g['name'] do
      gid g['gid'] || nil
      system g['system'] || nil
      members g['members']
    end
  end
end

# remove groups
node['accounting']['implode_groups'].each do |groupname|
  group groupname do
    action :remove
  end
end