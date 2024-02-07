local k = import "github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet"; 
local copsDeployment = import "../functions/deployment/deployment.libsonnet"; 

function(payload, metadata) 
    copsDeployment(k, payload, metadata).return



