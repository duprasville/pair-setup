if node.machine_type == 'personal'

  include_recipe "osx::command_line_tools"
  include_recipe "osx::ssh_keygen"
  
  chef_gem 'github_api' do
    options "--no-ri --no-rdoc"
    version '0.10.2'
  end
  require 'github_api'

  ruby_block "Add ssh key to github" do
    block do
      github_api.users.keys.create :title => "#{node.current_user}@#{node.fqdn}", :key => public_key
    end
    not_if { github_api.users.keys.all.any? { |k| public_key.include? k['key']} }
  end

  ssh_known_hosts_entry "github.com"
end
