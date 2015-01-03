case node['platform_version']
when /10\.8(\.\d+)?/
  default['osx_command_line_tools']['checksum'] = "635c1cf6c93b397ef882c27211ef01e54e5b1d9d2d92fc870f1e07efd54cfe35"
  default['osx_command_line_tools']['file_name'] = "command_line_tools_os_x_mountain_lion_for_xcode_october_2013.dmg"
  default['osx_command_line_tools']['url'] = "http://devimages.apple.com/downloads/xcode/#{node['osx_command_line_tools']['file_name']}"
  default['osx_command_line_tools']['app_name'] = "Command Line Tools (Mountain Lion)"
when /10\.9(\.\d+)?/
  default['osx_command_line_tools']['url'] = "http://swcdn.apple.com/content/downloads/45/59/031-1006/2jafq1kzp69xghbk01rq6iysiyybtcv3uh/CLTools_Executables.pkg"
  default['osx_command_line_tools']['checksum'] = "c9ef9c1e85b602762844a76a8e9c8fec6f609dc91a126d86570cac796677a6ca"
  default['osx_command_line_tools']['file_name'] = "CLTools_Executables.pkg"
else
  Chef::Log.warn "This cookbook only supports OSX 10.8 and 10.9.  You have version #{node['platform_version']}"
end