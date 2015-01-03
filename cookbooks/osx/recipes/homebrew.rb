homebrew_go = "#{Chef::Config[:file_cache_path]}/homebrew_go"
HOMEBREW_CACHE = '/Library/Caches/Homebrew'

remote_file homebrew_go do
  source "https://raw.githubusercontent.com/Homebrew/install/master/install"
  mode 00755
end

execute homebrew_go do
  not_if { File.exist? '/usr/local/bin/brew' }
end

execute "sudo chgrp -R developers /usr/local"
execute "sudo chmod -R g+w /usr/local"

execute "sudo chgrp -R developers #{HOMEBREW_CACHE}" do
  only_if { File.exist? HOMEBREW_CACHE }
end

execute "sudo chmod -R g+w #{HOMEBREW_CACHE}" do
  only_if { File.exist? HOMEBREW_CACHE }
end

package 'git' do
  not_if "which git"
end

execute "update homebrew from github" do
  command "/usr/local/bin/brew update || true"
end

node['homebrew']['packages'].each do |package_name|
  package package_name
end
