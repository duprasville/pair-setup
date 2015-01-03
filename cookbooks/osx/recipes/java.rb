# Java 6
dmg_package "JavaForOSX" do
  source "http://support.apple.com/downloads/DL1572/en_US/"
  type "pkg"
  volumes_dir "Java for OS X 2014-001"
  package_id "com.apple.pkg.JavaForMacOSX107"
  checksum "97bc9b3c47af1f303710c8b15f2bcaedd6b40963c711a18da8eac1e49690a8a0"
  action :install
end

# Java 7
bash "#{Chef::Config[:file_cache_path]}/jdk-7u65-macosx-x64.dmg" do
  cwd "#{Chef::Config[:file_cache_path]}"
  code "curl -OLk --header \"Cookie: oraclelicense=accept-securebackup-cookie\" http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-macosx-x64.dmg"
  action :run
  not_if { `/usr/libexec/java_home -v 1.7`.include? 'jdk1.7.0_65.jdk' }
end

dmg_package 'JDK 7 Update 65' do
  source "file://#{Chef::Config[:file_cache_path]}/jdk-7u65-macosx-x64.dmg"
  type "pkg"
  action :install
  package_id 'com.oracle.jdk7u65'
end

# Java 8
bash "#{Chef::Config[:file_cache_path]}/jdk-8u25-macosx-x64.dmg" do
  cwd "#{Chef::Config[:file_cache_path]}"
  code "curl -OLk --header 'Cookie: oraclelicense=accept-securebackup-cookie' http://download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-macosx-x64.dmg"
  action :run
  not_if { `/usr/libexec/java_home -v 1.8`.include? 'jdk1.8.0_25.jdk' }
end

dmg_package 'JDK 8 Update 25' do
  source "file://#{Chef::Config[:file_cache_path]}/jdk-8u25-macosx-x64.dmg"
  type "pkg"
  action :install
  package_id 'com.oracle.jdk8u25'
end
