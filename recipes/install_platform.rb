#
# Cookbook Name:: atg
# Recipe:: install_platform
#
# Install and configure Oracle Commerce 11.1
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

###
# Check requirements
###
raise "Installation package must be provided! Please set 'atg.install.platform' attribute" if node[:atg][:install][:platform].empty?

include_recipe "weblogic::default"

###
# Download installer
###
remote_file ::File.join(node[:weblogic][:install_dir], ::File.basename(node[:atg][:install][:platform])) do
  source node[:atg][:install][:platform]
  retries 2
  use_conditional_get true
  use_etag true
  use_last_modified true
  mode "0755"
  action :create_if_missing
end

###
# Run installer
###
directory node[:atg][:install_dir] do
  owner "oracle"
  group "oinstall"
end

platform_response_file = ::File.join(node[:weblogic][:install_dir], "atg_platform.properties")

template platform_response_file do
  variables({
    :atg_install_dir => node[:atg][:install_dir]
  })
end

bash "clean #{node[:atg][:install_dir]}" do
  code "rm -rf #{node[:atg][:install_dir]}/*"
  not_if { File.exists?(::File.join(node[:weblogic][:install_dir], ".atg.platform.install.done")) }
end

bash "install atg platform" do
  creates ::File.join(node[:weblogic][:install_dir], ".atg.platform.install.done")
  code <<-END
    runuser -l oracle -c "\
    export ATGJRE=`which java`; \
    #{::File.join(node[:weblogic][:install_dir], ::File.basename(node[:atg][:install][:platform]))} \
    -i silent \
    -f #{platform_response_file}" && \
    touch #{::File.join(node[:weblogic][:install_dir], ".atg.platform.install.done")}
  END
end

###
# Create helper directories
###
directory node[:atg][:ear_dir] do
  owner "oracle"
  group "oinstall"
end

