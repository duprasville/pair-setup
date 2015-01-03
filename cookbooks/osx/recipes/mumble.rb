dmg_package "Mumble" do
  source node['mumble']['download_url']
  checksum node['mumble']['checksum']
  volumes_dir "Mumble #{node['mumble']['version']}"
  action :install
end
