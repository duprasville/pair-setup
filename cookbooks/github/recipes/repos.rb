include_recipe "github::add_ssh_key"

node['github']['repos'].each do |path, repo|
  github path do
    repository repo
  end
end