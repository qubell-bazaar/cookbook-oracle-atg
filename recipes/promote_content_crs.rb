bash "CRS/baseline.sh" do
  cwd "#{node[:endeca][:root_dir]}/endeca/Apps/CRS/control"
  user "oracle"
  group "oinstall"
  code <<-EEND
    ./baseline.sh weblogic:#{node[:weblogic][:password]} admin:#{node[:atg][:password]}
  EEND
end

bash "CRS/promote_content.sh" do
  cwd "#{node[:endeca][:root_dir]}/endeca/Apps/CRS/control"
  user "oracle"
  group "oinstall"
  code <<-EEND
    ./promote_content.sh
  EEND
end
