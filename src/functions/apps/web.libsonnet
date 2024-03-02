local deployment = import "../base/deployment/deployment.libsonnet"; 
local pdb = import "../base/pdb.libsonnet"; 
local sa = import "../base/serviceaccount.libsonnet"; 
local es = import "../base/externalsecrets.libsonnet";

function(k, payload, metadata){
    return: std.filter(
        function(e) e != {}, 
        [
            deployment(k, payload, metadata).return, 
            pdb(k, payload, metadata).return, 
            sa(k, payload, metadata).return, 
            es(k, payload, metadata).return, 
        ]
    )
}