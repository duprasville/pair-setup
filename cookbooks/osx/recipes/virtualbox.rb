dmg_package "VirtualBox" do
  source node.virtualbox.download_url
  checksum node.virtualbox.checksum
  type 'pkg'
end