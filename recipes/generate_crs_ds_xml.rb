dsmap = {
  "atg" => "ATGPublishingDS",
  "atgprod" => "ATGProductionDS",
  "switcha" => "ATGSwitchingDS_A",
  "switchb" => "ATGSwitchingDS_B"
}

node[:atg][:ds].each do |key, val|
  template ::File.join(node[:atg][:domain_path], "config/jdbc", "#{dsmap[key]}-1000-jdbc.xml") do
    source "ds.xml.erb"
    owner node[:atg][:user]
    variables({
      :name => dsmap[key],
      :dbhost => node[:atg][:db][:host],
      :dbport => node[:atg][:db][:port],
      :dbsid => node[:atg][:db][:sid],
      :username => val["username"],
      :password => val["password"]
    })
  end
end

bash "update config.xml" do
  code <<-END
    sed -i -e 's/-[0-9][0-9][0-9][0-9]-jdbc.xml/-1000-jdbc.xml/g' #{::File.join(node[:atg][:domain_path], "config/config.xml")}
  END
end
