unless ::File.directory?("/Applications/Flowdock.app")
  puts node.flowdock.download_url
  
  remote_file "#{Chef::Config[:file_cache_path]}/Flowdock.zip" do
    source node.flowdock.download_url
  end

  execute "unzip Flowdock" do
    command "unzip #{Chef::Config[:file_cache_path]}/Flowdock.zip"
    cwd "/Applications"
  end
end
