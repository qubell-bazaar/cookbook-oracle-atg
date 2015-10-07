wlst "create ATGProduction" do
  user "oracle" if node.platform_family?("rhel")
  weblogic_home node[:weblogic][:weblogic_home]
  code <<-END
connect('#{node[:weblogic][:username]}', '#{node[:weblogic][:password]}', 't3://#{node[:weblogic][:admin_console]}')
edit()
startEdit()

try:
  s = create('#{node[:atg][:servers][:production][:name]}', 'Server')
except:
  s = getMBean('/Servers/#{node[:atg][:servers][:production][:name]}')
s.setListenAddress("0.0.0.0")
s.setListenPort(#{node[:atg][:servers][:production][:port]})
s.setMachine(getMBean("/Machines/#{node[:atg][:servers][:production][:machine]}"))
st = s.getServerStart()
st.setArguments('#{node[:atg][:servers][:production][:arguments].join(" ")}')

save()
activate()

start('#{node[:atg][:servers][:production][:name]}', 'Server', 't3://0.0.0.0:#{node[:atg][:servers][:production][:port]}')
  END
end

directory node[:atg][:servers][:production][:config_dir] do
  owner "oracle"
  group "oinstall"
end

cookbook_file "#{node[:atg][:servers][:production][:config_dir]}/atgproduction.tar.gz"

bash "unpack atgproduction.tar.gz" do
  cwd node[:atg][:servers][:production][:config_dir]
  code <<-EEND
    tar -xzf atgproduction.tar.gz && chown -R oracle:oinstall *
  EEND
end
