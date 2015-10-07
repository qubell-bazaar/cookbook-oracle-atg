#
# Cookbook Name:: atg
# Recipe:: install_crs
#
# Install and configure Oracle Commerce 11.1 Reference Store
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

###
# Check requirements
###
raise "Installation package must be provided! Please set 'atg.install.crs' attribute" if node[:atg][:install][:crs].empty?

include_recipe "atg::install_platform"

###
# Download installer
###
remote_file ::File.join(node[:weblogic][:install_dir], ::File.basename(node[:atg][:install][:crs])) do
  source node[:atg][:install][:crs]
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
crs_response_file = ::File.join(node[:weblogic][:install_dir], "atg_crs.properties")

template crs_response_file do
  variables({
    :atg_install_dir => node[:atg][:install_dir]
  })
end

bash "clean #{::File.join(node[:atg][:install_dir], "CommerceReferenceStore")}" do
  code "rm -rf #{node[:atg][:install_dir]}/CommerceReferenceStore"
  not_if { File.exists?(::File.join(node[:weblogic][:install_dir], ".atg.crs.install.done")) }
end

bash "install atg crs" do
  creates ::File.join(node[:weblogic][:install_dir], ".atg.crs.install.done")
  code <<-END
    runuser -l oracle -c "\
    export ATGJRE=`which java`; \
    #{::File.join(node[:weblogic][:install_dir], ::File.basename(node[:atg][:install][:crs]))} \
    -i silent \
    -f #{crs_response_file}" && \
    touch #{::File.join(node[:weblogic][:install_dir], ".atg.crs.install.done")}
  END
end

###
# Update WebLogic domain env
###
remote_file ::File.join(node[:weblogic][:domain_home], node[:weblogic][:domain_name], "lib", "protocol.jar") do
  owner "oracle"
  group "oinstall"
  mode "0644"
  source "file://#{::File.join(node[:atg][:install_dir], "DAS/lib/protocol.jar")}"
end

env_file = ::File.join(node[:weblogic][:domain_home], node[:weblogic][:domain_name], "bin", "setDomainEnv.sh")
bash "update setDomainEnv.sh" do
  code <<-EEND
  cat <<END >> #{env_file}
# CRS-CHEF-FIX
# CIM - Adding Database Driver to CLASSPATH
CLASSPATH="\\${CLASSPATH}:#{node[:weblogic][:middleware_home]}/oracle_common/modules/oracle.jdbc_11.2.0/ojdbc6.jar"; export CLASSPATH
# CIM - Prepending protocol.jar CLASSPATH
CLASSPATH="#{::File.join(node[:weblogic][:domain_home], node[:weblogic][:domain_name])}/lib/protocol.jar:\\${CLASSPATH}"; export CLASSPATH
END
  EEND
  not_if "grep 'CRS-CHEF-FIX' #{env_file}"
end
