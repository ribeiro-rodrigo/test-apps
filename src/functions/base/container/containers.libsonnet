local envSpec = import "./envSpec.libsonnet"; 
local probesSpec = import "./probes.libsonnet"; 
local resources = import "./resources.libsonnet"; 

/*function(k, payload, metadata){
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
} */

function(k, payload, metadata){
    local container = k.core.v1.container, 
    local properties = payload.properties, 

    return: container.new(metadata.labels.alias, properties.image.address)+ 
            (if std.get(properties, "command", default=null) != null then container.withCommand(properties.command) else {}) + 
            container.withEnv(envSpec(metadata.labels.app, properties.environments).return) + 
            container.resources.withLimits(resources(properties.resources).limits) + 
            container.resources.withRequests(resources(properties.resources).requests) + 
            if properties.image.pull_always then container.withImagePullPolicy("Always") else container.withImagePullPolicy("IfNotPresent")
}