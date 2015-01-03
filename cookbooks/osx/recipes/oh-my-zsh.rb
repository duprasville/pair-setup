include_recipe "github::add_ssh_key"

github "#{ENV['HOME']}/.oh-my-zsh" do
  repository "robbyrussell/oh-my-zsh" 
end

github "#{ENV['HOME']}/.oh-my-zsh-custom" do
  repository "duprasville/oh-my-zsh-custom"
end

bash "copy .zshrc" do
  cwd "#{ENV['HOME']}"
  code <<-EOF
    cp .zshrc .zshrc.orig
    cp #{ENV['HOME']}/.oh-my-zsh-custom/templates/zshrc.zsh-template #{ENV['HOME']}/.zshrc
  EOF
  not_if 'grep -q ZSH_CUSTOM=\$HOME/.oh-my-zsh-custom $HOME/.zshrc'
end

execute "sudo chsh -s /bin/zsh #{ENV['USER']}" do
  not_if { node['shell'] == '/bin/zsh' }
end
