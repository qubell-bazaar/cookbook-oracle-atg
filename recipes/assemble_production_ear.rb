bash "assemble atg_production.ear" do
  user "oracle"
  group "oinstall"
  code <<-EEND
    export DYNAMO_HOME=#{node[:atg][:home_dir]}
    export ATGJRE=`which java`
    #{node[:atg][:home_dir]}/bin/runAssembler -pack -server "ATGProduction" -displayname "ATGProduction" \
    #{node[:atg][:ear_dir]}/ATGProduction.ear \
    -layer EndecaPreview \
    -m \
    DafEar.Admin \
    DPS \
    DSS \
    ContentMgmt \
    DCS.PublishingAgent \
    DCS.AbandonedOrderServices \
    ContentMgmt.Endeca.Index \
    DCS.Endeca.Index \
    Store.Endeca.Index \
    DAF.Endeca.Assembler \
    DCS.Endeca.Index.SKUIndexing \
    Store.Storefront \
    Store.EStore.International \
    Store.Endeca.International \
    Store.Storefront.NoPublishing \
    Store.Fluoroscope \
    Store.Fulfillment \
    PublishingAgent \
    Store.Storefront.NoPublishing.International
  EEND
end

node.set[:atg][:ears][:production] = "#{node[:atg][:ear_dir]}/ATGProduction.ear"
