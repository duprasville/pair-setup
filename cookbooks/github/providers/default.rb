action :checkout do
  if node.machine_type == 'personal'
    clone_url = "git@github.com:#{new_resource.repository}.git"
    origin_url = clone_url
  else
    clone_url = "https://#{node.oauth_token}@github.com/#{new_resource.repository}.git"
    origin_url = "https://github.com/#{new_resource.repository}.git"
  end

  git new_resource.path do
    repository clone_url
  end

  execute "git remote set-url origin #{origin_url}" do
    cwd new_resource.path
    only_if "test `git config --get remote.origin.url` = #{clone_url}"
  end
end