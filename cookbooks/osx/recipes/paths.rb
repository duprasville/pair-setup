# We are not running as root so create the paths file from the template
# and then sudo cp it to /etc/paths
template "#{Chef::Config[:file_cache_path]}/paths" do
  source "paths.erb"
end

execute "sudo cp #{Chef::Config[:file_cache_path]}/paths /etc/paths"