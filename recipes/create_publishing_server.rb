wlst "create ATGPublishing" do
  user "oracle" if node.platform_family?("rhel")
  weblogic_home node[:weblogic][:weblogic_home]
  code <<-END
connect('#{node[:weblogic][:username]}', '#{node[:weblogic][:password]}', 't3://#{node[:weblogic][:admin_console]}')
edit()
startEdit()

try:
  s = create('#{node[:atg][:servers][:publishing][:name]}', 'Server')
except:
  s = getMBean('/Servers/#{node[:atg][:servers][:publishing][:name]}')
s.setListenAddress("0.0.0.0")
s.setListenPort(#{node[:atg][:servers][:publishing][:port]})
s.setMachine(getMBean("/Machines/#{node[:atg][:servers][:publishing][:machine]}"))
st = s.getServerStart()
st.setArguments('#{node[:atg][:servers][:publishing][:arguments].join(" ")}')

save()
activate()

start('#{node[:atg][:servers][:publishing][:name]}', 'Server', 't3://0.0.0.0:#{node[:atg][:servers][:publishing][:port]}')
  END
end

directory node[:atg][:servers][:publishing][:config_dir] do
  owner "oracle"
  group "oinstall"
end

cookbook_file "#{node[:atg][:servers][:publishing][:config_dir]}/atgpublishing.tar.gz"

bash "unpack atgpublishing.tar.gz" do
  cwd node[:atg][:servers][:publishing][:config_dir]
  code <<-EEND
    tar -xzf atgpublishing.tar.gz && chown -R oracle:oinstall *
  EEND
end
