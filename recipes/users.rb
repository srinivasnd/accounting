
node['accounting']['users'].each do |username|

  bag = data_bag_item("users", username) rescue nil

  home_dir = (username == 'root') ? '/root' : "/home/#{username}"

  user username do
    uid (bag and bag.has_key? 'uid') ? bag["uid"].to_i : nil
    home home_dir
    shell (bag and bag.has_key? 'shell') ? bag["shell"] : '/bin/bash'
    password `python -c "import crypt; print crypt.crypt('#{bag['password']}')"`.strip if bag and bag.has_key? "password"
    system (bag and bag.has_key? "system") ? bag['system'] : false
    supports :manage_home => true
  end

  if bag
    directory "#{home_dir}/.ssh" do
      owner username
      group username
      mode "0755"
    end

    if bag.has_key? "ssh_keys"
      file "#{home_dir}/.ssh/authorized_keys" do
        owner username
        group username
        mode "0644"
        action :touch
      end

      ruby_block "write_authorized_keys_for_#{username}" do
        block do
          File.truncate("#{home_dir}/.ssh/authorized_keys", 0)

          authorized_key_file = File.open("#{home_dir}/.ssh/authorized_keys", 'r+')

          bag["ssh_keys"].each do |key|
            authorized_key_file.write(key + "\n")
          end
          authorized_key_file.close
        end
      end
    end

    if bag.has_key? "public_key" and bag["public_key"] != ""
      file "#{home_dir}/.ssh/id_rsa.pub" do
        owner username
        group username
        mode "0644"
        action :touch
      end

      ruby_block "write_public_key_for_#{username}" do
        block do
          public_key_file = File.open("#{home_dir}/.ssh/id_rsa.pub", "w")
          public_key_file.write(bag["public_key"])
          public_key_file.close
        end
      end
    end

    if bag.has_key? "private_key" and bag["private_key"] != ""
      file "#{home_dir}/.ssh/id_rsa" do
        owner username
        group username
        mode "0600"
        action :touch
      end

      ruby_block "write_private_key_for_#{username}" do
        block do
          public_key_file = File.open("#{home_dir}/.ssh/id_rsa", "w")
          public_key_file.write(bag["private_key"])
          public_key_file.close
        end
      end
    end    
  end

end

node['accounting']['implode_users'].each do |username|
  user username do
    action :remove
  end
end