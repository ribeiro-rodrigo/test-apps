local makeRules = import "./funcs/make_rule.libsonnet"; 

function(k, trait, payload, metadata){

    local ingress = k.networking.v1.ingress, 

    local filterProtocol = function(protocol, endpoints)
        std.filter(function(e) e.type == protocol, endpoints), 
    
    local groupHosts = function(endpoints)
        std.map(function(x) x.properties.host + "." + x.properties.domain, std.set(endpoints, keyF=function(x) x.properties.host + "." + x.properties.domain)),


    local httpEndpoints = filterProtocol("http", trait.properties.private.endpoints), 
    local httpHosts = groupHosts(httpEndpoints), 

    local httpIngress = std.map(function(e) 
        ingress.new("http-"+metadata.labels.app) + 
        ingress.metadata.withLabels(metadata.labels) + 
        makeRules(ingress, httpHosts, httpEndpoints, metadata)
    ,httpHosts), 

    local grpcEndpoints = filterProtocol("grpc", trait.properties.private.endpoints), 
    local grpcHosts = groupHosts(grpcEndpoints), 

    local grpcIngress = std.map(function(e)
        ingress.new("grpc-"+metadata.labels.app) + 
        ingress.metadata.withLabels(metadata.labels) + 
        makeRules(ingress, grpcHosts, grpcEndpoints, metadata)
    ,grpcHosts), 

    return: httpIngress + grpcIngress, 

}