dmg_package "IntelliJ IDEA #{node['intellij']['major_version']}" do
  source node.intellij.download_url
  checksum node.intellij.checksum
  action :install
end

directory "#{ENV['HOME']}/Library/Preferences/IntelliJIdea#{node['intellij']['major_version']}"

cookbook_file "#{ENV['HOME']}/Library/Preferences/IntelliJIdea#{node['intellij']['major_version']}/idea#{node['intellij']['major_version']}.key" do
  source "idea.key"
end
