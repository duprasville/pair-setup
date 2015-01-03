execute "curl -#L https://get.rvm.io | bash -s #{node.rvm.version} --autolibs=3" do
  only_if { `type rvm && rvm version`.match(/#{node.rvm.version}/).nil? }
end

node.rvm.rubies.each do |ruby|
  execute "rvm install #{ruby}"
end

execute "rvm --default use #{node['rvm']['default_ruby']}" do
  only_if { node['rvm']['default_ruby'] }
end