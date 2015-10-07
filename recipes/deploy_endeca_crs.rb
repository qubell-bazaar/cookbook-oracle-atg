directory ::File.join(node[:endeca][:root_dir], "endeca", "Apps") do
  owner "oracle"
  group "oinstall"
end

#template ::File.join(node[:atg][:install_dir], "batch_endeca.cim") do
#  owner "oracle"
#  group "oinstall"
#  mode "0644"
#  variables({
#    :atg_path => node[:atg][:install_dir],
#    :apps_path => ::File.join(node[:endeca][:root_dir], "endeca", "Apps"),
#    :cas_path => ::File.join(node[:endeca][:root_dir], "endeca", "CAS/11.1.0"),
#    :tools_path => ::File.join(node[:endeca][:root_dir], "endeca", "Tools/11.1.0"),
#    :platform_path => ::File.join(node[:endeca][:root_dir], "endeca", "PlatformServices/11.1.0"),
#    :mdex_path => ::File.join(node[:endeca][:root_dir], "endeca", "MDEX/6.5.1"),
#  })
#end

#bash "CIM - run endeca import" do
#  user "oracle"
#  group "oinstall"
#  code <<-EEND
#    export ATGJRE=`which java`;
#    #{node[:atg][:install_dir]}/home/bin/cim.sh -batch #{::File.join(node[:atg][:install_dir], "batch_endeca.cim")}
#  EEND
#end

template ::File.join(node[:atg][:install_dir], "endeca_crs.response") do
  owner "oracle"
  group "oinstall"
  mode "0644"
  variables({
    :atg_path => node[:atg][:install_dir],
    :apps_path => ::File.join(node[:endeca][:root_dir], "endeca", "Apps"),
    :cas_path => ::File.join(node[:endeca][:root_dir], "endeca", "CAS/11.1.0"),
    :tools_path => ::File.join(node[:endeca][:root_dir], "endeca", "Tools/11.1.0"),
    :platform_path => ::File.join(node[:endeca][:root_dir], "endeca", "PlatformServices/11.1.0"),
    :mdex_path => ::File.join(node[:endeca][:root_dir], "endeca", "MDEX/6.5.1"),
  })
end

bash "Deploy Endeca CRS application" do
  cwd "#{node[:endeca][:root_dir]}/endeca/Tools/11.1.0/deployment_template/bin"
  user "oracle"
  group "oinstall"
  code <<-EEND
    source #{node[:endeca][:root_dir]}/endeca/MDEX/6.5.1/mdex_setup_sh.ini
    source #{node[:endeca][:root_dir]}/endeca/PlatformServices/11.1.0/setup/installer_sh.ini
    ./deploy.sh --app #{node[:atg][:install_dir]}/CommerceReferenceStore/Store/Storefront/deploy/deploy.xml < #{::File.join(node[:atg][:install_dir], "endeca_crs.response")}
  EEND
  creates "#{node[:endeca][:root_dir]}/endeca/Apps/CRS"
end

bash "Initialize Endeca CRS application" do
  cwd "#{node[:endeca][:root_dir]}/endeca/Apps/CRS/control"
  user "oracle"
  group "oinstall"
  code <<-EEND
    source #{node[:endeca][:root_dir]}/endeca/MDEX/6.5.1/mdex_setup_sh.ini
    source #{node[:endeca][:root_dir]}/endeca/PlatformServices/11.1.0/setup/installer_sh.ini
    export ENDECA_CONF=#{node[:endeca][:root_dir]}/endeca/PlatformServices/workspace
    eaccmd.sh describe-app --app CRS || ./initialize_services.sh
  EEND
end

cookbook_file "#{node[:endeca][:root_dir]}/endeca/Apps/CRS/control/baseline.sh" do
  owner "oracle"
  group "oinstall"
  mode "0755"
end
