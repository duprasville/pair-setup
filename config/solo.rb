current_dir = File.expand_path(File.dirname(__FILE__))

file_cache_path  "#{current_dir}/../.chef/cache"
file_backup_path "#{current_dir}/../.chef/backup"
cache_options(   :path => "#{current_dir}/../.chef/checksums", :skip_expires => true )

role_path "#{current_dir}/../roles"
cookbook_path ["#{current_dir}/../cookbooks"]

# Ohai tries to determine gcc version at the beginning of the chef run 
# before command line tools have been installed. Mavericks responds to this
# by prompting to install the command line tools. To avoid this we have disabled
# the c plugin. This can be reconsidered if a recipe needs gcc info from ohai for 
# some reason.
Ohai::Config[:disabled_plugins] = ["c"]
