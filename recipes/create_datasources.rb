node[:atg][:datasources].each_value do |ds|
  weblogic_datasource ds["name"] do
    jndi_name ds["jndi_name"]
    jdbc_url ds["jdbc_url"]
    driver_name ds["driver_name"]
    driver_props ds["driver_props"]
    password ds["password"]
    pool_props ds["pool_props"]
    target ds["target"]
    action :create
  end
end
