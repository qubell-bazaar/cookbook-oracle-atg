wlst "shutdown ATGPublishing" do
  user "oracle" if node.platform_family?("rhel")
  weblogic_home node[:weblogic][:weblogic_home]
  code <<-END
connect('#{node[:weblogic][:username]}', '#{node[:weblogic][:password]}', 't3://#{node[:weblogic][:admin_console]}')
try:
  shutdown('#{node[:atg][:servers][:publishing][:name]}', 'Server', ignoreSessions='true', force='true')
except:
  pass
  END
end
