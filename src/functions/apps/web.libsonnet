local deployment = import "../base/deployment/deployment.libsonnet"; 
local pdb = import "../base/pdb.libsonnet"; 
local sa = import "../base/serviceaccount.libsonnet"; 

function(k, payload, metadata){
    return: [
                deployment(k, payload, metadata).return, 
                pdb(k, payload, metadata).return, 
                sa(k, payload, metadata).return, 
            ]
}