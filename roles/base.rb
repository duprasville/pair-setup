name "base"
description "base role for workstation setup"

run_list %w[
  recipe[osx::passwordless_sudo]
  recipe[osx::paths]
  recipe[osx::command_line_tools]
  recipe[osx::java]
  recipe[osx::oh-my-zsh]
  recipe[osx::httpie]
  recipe[osx::homebrew]
  recipe[osx::rvm]
  recipe[osx::intellij]
  recipe[osx::sublime]
  recipe[osx::iterm2]
  recipe[osx::chrome]
  recipe[osx::firefox]
  recipe[osx::flowdock]
  recipe[osx::settings]
  recipe[osx::virtualbox]
  recipe[osx::mumble]
  recipe[osx::gw]
  recipe[github::repos]
]

override_attributes(
  :ssh_known_hosts => { 
    :file => "#{ENV['HOME']}/.ssh/known_hosts"
  },
  :homebrew => {
    :packages => [
      'git',
      'chromedriver',
      'hub',
      'csshx'
    ]
  },
  :rvm => {
    :version => 'stable'
    # :rubies => ['1.9.3'],
    # :default_ruby => '1.9.3'
  },
  :osx => {
    :settings => {
      :dock => {
        "domain" => "com.apple.dock",
        "autohide" => true,
        "showhidden" => true,
        "tilesize" => 40,
        "magnification" => 1
      },
      :keyboard => {
        "domain" => "NSGlobalDomain",
        "KeyRepeat" => 0,
        "InitialKeyRepeat" => 15,
        "ApplePressAndHoldEnabled" => false
      }
    }
  }
)
