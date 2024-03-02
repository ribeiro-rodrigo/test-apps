local k = import "github.com/jsonnet-libs/k8s-libsonnet/1.26/main.libsonnet"; 

local transform = import "../functions/engine/transform.libsonnet"; 
local creation = import "../functions/engine/create.libsonnet"; 

local workload = import "../functions/engine/workloads.libsonnet"; 

function(payload, metadata)
    transform(
        workload(
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



