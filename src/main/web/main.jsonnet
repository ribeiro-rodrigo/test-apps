local k = import "github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet"; 

local web = import "../../functions/apps/web.libsonnet"; 

local transform = import "../../functions/engine/transform.libsonnet"; 
local creation = import "../../functions/engine/create.libsonnet"; 

function(payload, metadata)
    transform(
        web(
            k, 
            payload, 
            metadata
        ).return 
        +
        creation(
            k, 
            payload, 
            metadata
        ).return, 

        k, 
        payload, 
        metadata
        
    ).return



