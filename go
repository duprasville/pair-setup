#!/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/ruby
require 'optparse'
require 'ostruct'
require 'fileutils'
require 'tempfile'

module OSXSetup
  class Options
    def self.parse(args)
      options = OpenStruct.new
      options.roles = ['base']

      opts = OptionParser.new do |opts|
        opts.banner = "Usage: go [options]"
        opts.separator ""

        opts.on("--roles role1,role2", Array, "The roles you would like to bootstrap.") do |t|
          options.roles = t
        end
      end

      opts.parse! args
      options
    end
  end

  class Bootstrapper
    PROJECT_NAME = 'pair-setup'
    REPO_NAME = "duprasville/#{PROJECT_NAME}.git"
    DEFAULT_REPO_DIR = "#{ENV['HOME']}/projects/#{PROJECT_NAME}"
    TOKEN_REGEX = /"app":\s\{.\s*?"name":\s"#{PROJECT_NAME}",.*?"token":\s"(.*?)"/m
    CLIENT_ID = "c643fd2be9686866d3af"
    CLIENT_SECRET = "cf4a0d038136eda6dcdf8e271be19840687d304a"
    GITHUB_AUTH_URL = "https://api.github.com/authorizations"
    TARBALL_URL = "https://api.github.com/repos/duprasville/#{PROJECT_NAME}/tarball"

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def go
      inform_user
      begin
        prompt_sudo
        collect_user_input
        install_repo
        install_chef
        run_chef_solo
        git_init_repo
      rescue Exception => e
        error "Bootstrap failed!"
        puts e.message
        exit 1
      end
    end

    private

    def blue; bold 34; end
    def white; bold 39; end
    def red; underline 31; end
    def reset; escape 0; end
    def bold(n); escape "1;#{n}" end
    def underline(n); escape "4;#{n}" end
    def escape(n); "\033[#{n}m" if STDOUT.tty? end
    def info(msg); puts "#{blue}==>#{white} #{msg.chomp}#{reset}" end
    def error(error); puts "#{red}Error: #{error.chomp}#{reset}" end

    def inform_user
      info "You are about to bootstrap your OSX computer. Here is what to expect:"
      puts <<-EOF.gsub(/^\s+-/, "-").gsub(/^\s+/,'  ')
      - To avoid sudo prompting during the bootstrap this script will ask for your
        sudo password at the beginning and give the admin group passwordless sudo access.
      - You will be prompted to select the type of machine as either a personal or pairing.
      - You will be prompted for your github username and password.
      - Chef will be installed and chef-solo will be used to install and configure
        all of the rest.
      EOF

      wait_for_user if STDIN.tty?
    end

    def prompt_sudo
      info "Ensuring sudo access..."
      system "sudo -k"
      system "sudo -p 'Please enter your sudo password: ' true"
    end

    def collect_user_input
      info "Determine machine type"
      options.machine_type    = prompt_machine_type

      info "Collecting github credentials"
      options.github_username = prompt_user "Please enter your Github username: "
      options.github_password = prompt_user "Please enter your Github password: ", false
      options.oauth_token     = oauth_token(options.github_username, options.github_password)

      if options.machine_type == :personal
        options.git_url = "git@github.com:#{REPO_NAME}"
        options.git_url_with_auth = options.git_url
      else
        options.git_url = "https://github.com/#{REPO_NAME}"
        options.git_url_with_auth = "https://#{options.oauth_token}@github.com/#{REPO_NAME}"
      end
    end

    def install_repo
      info "Installing #{PROJECT_NAME} repository..."
      if repo_installed?
        info "Repository is already installed."
      else
        FileUtils.mkdir_p project_home
        curl_flags = %Q[-H "Authorization: token #{options.oauth_token}" -#fSL]
        Dir.chdir project_home do
          system "curl #{curl_flags} #{TARBALL_URL} | /usr/bin/tar xz -m --strip 1"
        end
      end
    end

    def install_chef
      info "Installing chef..."
      if chef_installed?
        info "#{`chef-solo -v`.strip} already installed."
      else
        system "curl -L https://www.chef.io/chef/install.sh | sudo bash -s -- -v 11.16.4"
      end

      system 'sudo chmod -R 777 /opt/chef/embedded' if File.exists? '/opt/chef/embedded'
    end

    def run_chef_solo
      info "Running chef-solo to bootstrap..."
      solo_cfg = "#{project_home}/config/solo.rb"
      node_file = create_node_file
      system "chef-solo -linfo -F doc -c '#{solo_cfg}' -j '#{node_file}'"
    end

    def git_init_repo
      Dir.chdir project_home do
        unless File.exist? ".git"
          # info "git should now be installed."
          # info "Running git init in #{PROJECT_NAME} repository and adding remote url"
          # system "git init"
          # system "git remote add origin #{options.git_url}"
          # system "git fetch #{options.git_url_with_auth} master:refs/remotes/origin/master"
          # system "git reset --hard origin/master"
        end
      end
    end

    def prompt_machine_type
      puts "Is this a personal or pairing machine?"
      puts "1. personal"
      puts "2. pairing"
      choice = get_character.chr
      if choice == '1'
        info "This is a personal machine!"
        :personal
      elsif choice == '2'
        info "This is a pairing machine!"
        :pairing
      else
        error "You must choose 1 or 2."
        prompt_machine_type
      end
    end

    def generate_oauth_token(github_username, github_password)
      info "Generating new oAuth token..."
      post_json = %Q['{
        "scopes":["repo", "user", "admin:public_key"],
        "client_id":"#{CLIENT_ID}",
        "client_secret":"#{CLIENT_SECRET}"}']
      shell_out "echo 'user=#{github_username}:#{github_password}' | curl -sd #{post_json} -K - #{GITHUB_AUTH_URL}"
    end

    def oauth_token(github_username, github_password)
      info "Checking for existing oAuth token..."
      shell_out("echo 'user=#{github_username}:#{github_password}' | curl -fsSK - #{GITHUB_AUTH_URL}") =~ TOKEN_REGEX
      if $1
        info "Existing token found."
        $1
      else
        result = generate_oauth_token(github_username, github_password)
        result =~ TOKEN_REGEX
        abort "Could not generate oAuth token:\n#{result}" unless $1
        $1
      end
    end

    def create_node_file
      node_file = Tempfile.new('node.json')
      node_file.write <<-NODE_JSON
        {
          "run_list": [
            #{options.roles.map { |role| %Q["role[#{role}]"] }.join(",")}
          ],
          "oauth_token": "#{options.oauth_token}",
          "machine_type": "#{options.machine_type.to_s}"
        }
      NODE_JSON
      node_file.close
      node_file.path
    end

    def chef_installed?
      File.exist? "/usr/bin/chef-solo"
    end

    def repo_installed?
      File.exist? "#{project_home}/go"
    end

    def shell_out(command)
      result = `#{command}`
      abort unless $?.to_i == 0
      result
    end

    def system(*args)
      abort unless Kernel.system(*args)
    end

    def project_home
      @project_home ||= if File.exist? __FILE__
        File.expand_path(File.dirname __FILE__)
      else
        DEFAULT_REPO_DIR
      end
    end

    def prompt_user(prompt, echo = true)
      stty_settings = shell_out "stty -g"
      print prompt if prompt
      begin
        system("stty -echo") unless echo
        $stdin.gets.chomp
      ensure
        system "stty #{stty_settings}"
        puts "\n" unless echo
      end
    end

    def get_character
      stty_settings = shell_out "stty -g"
      system "stty raw -echo"
      STDIN.getbyte
    ensure
      system "stty #{stty_settings}"
    end

    def wait_for_user
      puts "Press ENTER to continue or any other key to abort"
      c = get_character
      abort unless c == 13 or c == 10
    end
  end
end

options = OSXSetup::Options.parse(ARGV)
OSXSetup::Bootstrapper.new(options).go
