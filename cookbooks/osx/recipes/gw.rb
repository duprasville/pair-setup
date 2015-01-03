github "#{ENV['HOME']}/projects/gdub" do
  repository "dougborg/gdub"
end

execute "sudo #{ENV['HOME']}/projects/gdub/install /usr/local"
