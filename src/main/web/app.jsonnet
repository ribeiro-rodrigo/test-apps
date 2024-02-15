local k = import "github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet"; 

local deployment = import "../functions/deployment/deployment.libsonnet"; 
local serviceAccount = import "../functions/serviceaccount.libsonnet"; 
local pdb = import "../functions/pdb.libsonnet"; 

local app = import "../functions/app.libsonnet"; 

function(payload, metadata)
    app([
        deployment(k, payload, metadata).return, 
        serviceAccount(k, payload, metadata).return, 
        pdb(k, payload, metadata).return

    ]).return 



