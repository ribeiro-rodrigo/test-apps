local all_endpoints = import "./funcs/all_endpoints_func.libsonnet"; 

function(k, trait, payload, metadata){
    local svc = k.core.v1.service, 

    return: [svc.new(
        "ing-" + metadata.labels.app, 
        {app: metadata.labels.app}, 
        std.map(
            function(endpoint) {
                port: endpoint.properties.port, targetPort: endpoint.properties.port
            },all_endpoints(trait)
        )
    ) + 
    svc.metadata.withLabels(metadata.labels)]
}