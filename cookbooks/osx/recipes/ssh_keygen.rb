if node.machine_type == 'personal'
  username = node['current_user']
  home_dir = "/Users/#{username}"
  fqdn = node['fqdn']

  execute "create ssh keypair for #{username}" do
    cwd home_dir
    user username
    command <<-KEYGEN.gsub(/^ +/, '')
      ssh-keygen -t rsa -f #{home_dir}/.ssh/id_rsa -N '' \
        -C '#{username}@#{fqdn}-#{Time.now.strftime('%FT%T%z')}'
      chmod 0600 #{home_dir}/.ssh/id_rsa
      chmod 0644 #{home_dir}/.ssh/id_rsa.pub
    KEYGEN

    creates "#{home_dir}/.ssh/id_rsa"
    not_if { ::File.exist? "#{home_dir}/.ssh/id_rsa" }
  end
end