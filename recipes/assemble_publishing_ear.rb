bash "assemble atg_publishing.ear" do
  user "oracle"
  group "oinstall"
  code <<-EEND
    export DYNAMO_HOME=#{node[:atg][:home_dir]}
    export ATGJRE=`which java`
    #{node[:atg][:home_dir]}/bin/runAssembler -pack -server "ATGPublishing" -displayname "ATGPublishing" \
    #{node[:atg][:ear_dir]}/ATGPublishing.ear \
    -m \
    DCS-UI.Versioned \
    BIZUI \
    PubPortlet \
    DafEar.Admin \
    ContentMgmt.Versioned \
    DCS.Versioned \
    DCS-UI \
    Store.EStore.Versioned \
    Store.Storefront \
    DCS-UI.SiteAdmin.Versioned \
    SiteAdmin.Versioned \
    ContentMgmt.Endeca.Index.Versioned \
    DCS.Endeca.Index.Versioned \
    Store.Endeca.Index.Versioned \
    DCS.Endeca.Index.SKUIndexing \
    Store.EStore.International.Versioned \
    Store.Endeca.International
  EEND
end

node.set[:atg][:ears][:publishing] = "#{node[:atg][:ear_dir]}/ATGPublishing.ear"
