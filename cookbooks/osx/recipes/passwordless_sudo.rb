require 'tempfile'

ruby_block "Set NOPASSWD for admin group in /etc/sudoers" do
	block do
    sudoers = "/etc/sudoers"
    tmp_sudoers = Tempfile.new("sudoers")

    Chef::Log.debug "Copying #{sudoers} to temp file #{tmp_sudoers.path}"
    system "sudo cp #{sudoers} #{tmp_sudoers.path}"
    system %Q{sudo sed -i "" -E 's/%admin[[:space:]]+ALL=\\(ALL\\)[[:space:]]+ALL/%admin  ALL=(ALL) NOPASSWD: ALL/' #{tmp_sudoers.path}}

		unless system("sudo visudo -cf #{tmp_sudoers.path}")
      Chef::Log.error("sudoers file failed validation!")
      Chef::Log.error(`sudo cat #{tmp_sudoers.path}`)
      Chef::Application.fatal!("Could not set NOPASSWD for admin group!")
    end

    system "sudo cp #{tmp_sudoers.path} #{sudoers}"
	end

  not_if "sudo grep -q '%admin  ALL=(ALL) NOPASSWD: ALL' /etc/sudoers"
  action :nothing
end.run_action :run

