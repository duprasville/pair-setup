dmg_package "Vagrant" do
  source node.vagrant.download_url
  checksum node.vagrant.checksum
  type "pkg"
end
