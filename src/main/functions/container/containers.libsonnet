local envSpec = import "./envSpec.libsonnet"; 
local probesSpec = import "./probes.libsonnet"; 
local resources = import "./resources.libsonnet"; 

function(k, payload, metadata){
    local container = k.core.v1.container, 

    local containers = [
        container.new(c.name, c.image.address) + 
        (if std.get(c, "command", default=null) != null then container.withCommand(c.command) else {}) + 
        (if std.get(c, "ports", default=null) != null then container.withPorts([
            {containerPort: p.port, protocol: p.protocol},
            for p in c.ports 
        ]) else {}) + 
        container.withEnv(envSpec(metadata.labels.app, c.environments).return) + 
        container.resources.withLimits(resources(c).limits) + 
        container.resources.withRequests(resources(c).requests) + 
        if c.image.pull_always then container.withImagePullPolicy("Always") else container.withImagePullPolicy("IfNotPresent") +
        probesSpec(c.healthcheck)

        for c in payload.containers
    ], 

    return: containers, 
}