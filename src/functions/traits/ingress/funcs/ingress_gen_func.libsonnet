local makeRules = import "./make_rule.libsonnet";
local makeAnnotations = import "./make_annotations.libsonnet";  

function(ingress, tier, class, endpoints, metadata){

    local filterProtocol = function(protocol, end)
        std.filter(function(e) e.type == protocol, end), 
    
    local groupHosts = function(endpoints)
        std.map(function(x) x.properties.host + "." + x.properties.domain, std.set(endpoints, keyF=function(x) x.properties.host + "." + x.properties.domain)),


    local httpEndpoints = filterProtocol("http", endpoints), 
    local httpHosts = groupHosts(httpEndpoints), 

    local httpIngress = if httpEndpoints != [] then
        [ingress.new("http-"+tier+"-"+metadata.labels.app) + 
        ingress.metadata.withAnnotations(makeAnnotations("http", class, tier, metadata).return) + 
        ingress.spec.withIngressClassName(class) + 
        ingress.metadata.withLabels(metadata.labels) + 
        makeRules(ingress, httpHosts, httpEndpoints, metadata)] else [],

    local grpcEndpoints = filterProtocol("grpc", endpoints), 
    local grpcHosts = groupHosts(grpcEndpoints), 

    local grpcIngress = if grpcEndpoints != [] then
        [ingress.new("grpc-"+tier+"-"+metadata.labels.app) + 
        ingress.metadata.withAnnotations(makeAnnotations("GRPC", class, tier, metadata).return) +
        ingress.spec.withIngressClassName(class) + 
        ingress.metadata.withLabels(metadata.labels) + 
        makeRules(ingress, grpcHosts, grpcEndpoints, metadata)] else [],

    return: std.flattenArrays([httpIngress, grpcIngress]), 

}