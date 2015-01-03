unless ::File.directory?("/Applications/iTerm.app")
  remote_file "#{Chef::Config[:file_cache_path]}/iTerm2.zip" do
    source node.iterm2.download_url
    checksum node.iterm2.checksum
  end

  execute "unzip iterm2" do
    command "unzip #{Chef::Config[:file_cache_path]}/iTerm2.zip"
    cwd "/Applications"
    not_if { File.directory?("/Applications/iTerm.app") }
  end
end