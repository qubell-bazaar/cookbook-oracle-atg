default[:atg][:install][:platform] = ""
default[:atg][:install][:crs] = ""
default[:atg][:install_dir] = ::File.join(node[:weblogic][:root_dir], "atg")
default[:atg][:home_dir] = ::File.join(node[:atg][:install_dir], "home")
default[:atg][:ear_dir] = ::File.join(node[:atg][:home_dir], "ears")

default[:atg][:password] = "123QweAsd"

default[:atg][:servers][:production][:name] = "ATGProduction"
default[:atg][:servers][:production][:port] = 7003
default[:atg][:servers][:production][:machine] = "localhost"
default[:atg][:servers][:production][:config_dir] = ::File.join(node[:atg][:home_dir], "servers", node[:atg][:servers][:production][:name])
default[:atg][:servers][:production][:arguments] = [ "-Xmx1G", "-XX:MaxPermSize=512m" ]

default[:atg][:servers][:publishing][:name] = "ATGPublishing"
default[:atg][:servers][:publishing][:port] = 7103
default[:atg][:servers][:publishing][:machine] = "localhost"
default[:atg][:servers][:publishing][:config_dir] = ::File.join(node[:atg][:home_dir], "servers", node[:atg][:servers][:publishing][:name])
default[:atg][:servers][:publishing][:arguments] = [ "-Xmx1G", "-XX:MaxPermSize=512m" ]

default[:atg][:datasources][:production][:name] = "ATGProductionDS"
default[:atg][:datasources][:production][:jndi_name] = "ATGProductionDS"
default[:atg][:datasources][:production][:jdbc_url] = "jdbc:oracle:thin:@127.0.0.1:1521:XE"
#default[:atg][:datasources][:production][:driver_name] = "oracle.jdbc.OracleDriver" # TODO: Look for XA
default[:atg][:datasources][:production][:driver_name] = "oracle.jdbc.xa.client.OracleXADataSource"
default[:atg][:datasources][:production][:username] = "atg_prod"
default[:atg][:datasources][:production][:password] = "password"
default[:atg][:datasources][:production][:driver_props] = { "user" => node[:atg][:datasources][:production][:username] }
default[:atg][:datasources][:production][:pool_props] = { "TestTableName" => "SQL SELECT 1 FROM DUAL", "MaxCapacity" => 40 }
default[:atg][:datasources][:production][:target] = [ node[:atg][:servers][:production][:name], node[:atg][:servers][:publishing][:name] ]

default[:atg][:datasources][:publishing][:name] = "ATGPublishingDS"
default[:atg][:datasources][:publishing][:jndi_name] = "ATGPublishingDS"
default[:atg][:datasources][:publishing][:jdbc_url] = "jdbc:oracle:thin:@127.0.0.1:1521:XE"
default[:atg][:datasources][:publishing][:username] = "atg_pub"
default[:atg][:datasources][:publishing][:password] = "password"
default[:atg][:datasources][:publishing][:driver_props] = { "user" => node[:atg][:datasources][:publishing][:username] }
default[:atg][:datasources][:publishing][:driver_name] = "oracle.jdbc.xa.client.OracleXADataSource"
default[:atg][:datasources][:publishing][:pool_props] = { "TestTableName" => "SQL SELECT 1 FROM DUAL", "MaxCapacity" => 40 }
default[:atg][:datasources][:publishing][:target] = [ node[:atg][:servers][:publishing][:name] ]

default[:atg][:datasources][:switcha][:name] = "ATGSwitchingDS_A"
default[:atg][:datasources][:switcha][:jndi_name] = "ATGSwitchingDS_A"
default[:atg][:datasources][:switcha][:jdbc_url] = "jdbc:oracle:thin:@127.0.0.1:1521:XE"
default[:atg][:datasources][:switcha][:username] = "switcha"
default[:atg][:datasources][:switcha][:password] = "password"
default[:atg][:datasources][:switcha][:driver_props] = { "user" => node[:atg][:datasources][:switcha][:username] }
default[:atg][:datasources][:switcha][:driver_name] = "oracle.jdbc.xa.client.OracleXADataSource"
default[:atg][:datasources][:switcha][:pool_props] = { "TestTableName" => "SQL SELECT 1 FROM DUAL", "MaxCapacity" => 100 }
default[:atg][:datasources][:switcha][:target] = [ node[:atg][:servers][:production][:name], node[:atg][:servers][:publishing][:name] ]

default[:atg][:datasources][:switchb][:name] = "ATGSwitchingDS_B"
default[:atg][:datasources][:switchb][:jndi_name] = "ATGSwitchingDS_B"
default[:atg][:datasources][:switchb][:jdbc_url] = "jdbc:oracle:thin:@127.0.0.1:1521:XE"
default[:atg][:datasources][:switchb][:username] = "switchb"
default[:atg][:datasources][:switchb][:password] = "password"
default[:atg][:datasources][:switchb][:driver_props] = { "user" => node[:atg][:datasources][:switchb][:username] }
default[:atg][:datasources][:switchb][:driver_name] = "oracle.jdbc.xa.client.OracleXADataSource"
default[:atg][:datasources][:switchb][:pool_props] = { "TestTableName" => "SQL SELECT 1 FROM DUAL", "MaxCapacity" => 100 }
default[:atg][:datasources][:switchb][:target] = [ node[:atg][:servers][:production][:name], node[:atg][:servers][:publishing][:name] ]

default[:atg][:ears][:production] = ""
default[:atg][:ears][:publishing] = ""
