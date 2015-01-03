dmg_package "Sublime Text 2" do
  dmg_name "Sublime%20Text%20#{node.sublime.version}"
  source node.sublime.download_url
  checksum node.sublime.checksum
end

link "/usr/local/bin/subl" do
  to "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
end

sublime_package_path = "#{ENV['HOME']}/Library/Application Support/Sublime Text 2/Packages"
sublime_user_path = File.join(sublime_package_path, "User")

directory sublime_user_path do
  recursive true
end

node.sublime.packages.each do |package|
  git ::File.expand_path(package["name"], sublime_package_path) do
    repository package["source"]
    action :sync
  end
end

template File.expand_path("Preferences.sublime-settings", sublime_user_path) do
  source "sublime-Preferences.sublime-settings.erb"
  action :create_if_missing
end

package_dir = "#{ENV['HOME']}/Library/Application Support/Sublime Text 2/Installed Packages"
filename    = "Package Control.sublime-package"

directory "#{ENV['HOME']}/Library/Application Support/Sublime Text 2/Installed Packages" do
  recursive true
end

remote_file "#{package_dir}/#{filename}" do
  source 'http://sublime.wbond.net/Package%20Control.sublime-package'
  :create_if_missing
end