if node['osx_command_line_tools']
  cltools_download_path = File.join(Chef::Config[:file_cache_path], node['osx_command_line_tools']['file_name'])

  case node['platform_version']
  when /10\.8(\.\d+)?/
    unless system("pkgutil --pkgs=com.apple.pkg.DeveloperToolsCLI")
      app_name = node['osx_command_line_tools']['app_name']

      installer = remote_file "Downloading Command Line Tools for Mountain Lion" do
        path cltools_download_path
        source node['osx_command_line_tools']['url']
        checksum node['osx_command_line_tools']['checksum']
        action :nothing
      end

      attach = execute "hdiutil attach '#{cltools_download_path}'" do
        action :nothing
      end

      install = execute "sudo installer -pkg '/Volumes/#{app_name}/#{app_name}.mpkg' -target /" do
        action :nothing
      end

      detach = execute "hdiutil detach '/Volumes/#{app_name}'" do
        action :nothing
      end

      installer.run_action :create
      attach.run_action :run
      install.run_action :run
      detach.run_action :run

    end
  when /10\.9(\.\d+)?/
    unless system("pkgutil --pkgs=com.apple.pkg.CLTools_Executables")

      bash "Install Command Line Tools for OSX 10.9 via softwareupdate" do
        code <<-SCRIPT
          touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
          PROD=$(softwareupdate -l | grep -B 1 "Developer" | head -n 1 | awk -F"*" '{print $2}')
          sudo softwareupdate -i $PROD -v
        SCRIPT
        action :nothing
      end.run_action :run
    end
  end
end