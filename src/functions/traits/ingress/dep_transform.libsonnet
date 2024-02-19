local all_endpoints = import "./funcs/all_endpoints_func.libsonnet"; 

function(k, dep, trait, payload, metadata){

    local container = k.core.v1.container, 
    local deployment = k.apps.v1.deployment,

    local c = dep.spec.template.spec.containers[0],

    local newC = c + container.withPorts([
        {protocol: "TCP", containerPort: e.properties.port}
        for e in all_endpoints(trait)
    ]), 

    return: dep + deployment.spec.template.spec.withContainers([newC])
}