osx-setup
=================

Contains chef recipes and scripts to bootstrap a development machine.

Installation
------------

To install paste in the following command but replace ```<username>``` with your github username:

```bash
ruby -e "$(curl -Lu <username> https://raw.githubusercontent.com/duprasville/pair-setup/master/go)"
```

You will then be prompted for your github password with a line resembling:

```bash 
Enter host password for user '<username>':
```

The install script should download and execute.  It assumes that you have a clean OS X install which does not include git.
Because git is not present it will use curl to download the osx-setup repository and will prompt you for your
github username and password.  After the repository is downloaded chef will be installed which will likely prompt for
your sudo password.  Once chef is installed chef-solo will be run to install all the things.

Common Problems
---------------

```
Github::Error::NotFound: DELETE https://api.github.com/user/keys/....
```

It is very likely you have executed osx-setup in the past (maybe on another machine). Since you executed the script, github has changed their oath permissions. You will need to revoke the osx-setup application from your github account. After doing this run the go script again and everything should work.

```
/opt/chef/embedded/lib/ruby/site_ruby/1.9.1/rubygems/dependency.rb:247:in 'to_specs': Could not find chef (>=0) amongst [...]
```

You likely already have rvm installed on your system and the script is expecting to run on the system ruby.  
Try: rvm use system
