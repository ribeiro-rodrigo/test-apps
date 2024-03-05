function(k, ing, trait, payload, metadata) {
    local ingress = k.networking.v1.ingress,
    local p = trait.properties, 

    local newIng = if ing.spec.ingressClassName == "alb" && (p.protocol.type == "http" || p.protocol.type == "grpc") then 
        ing + ingress.metadata.withAnnotations(
            ing.metadata.annotations + 
            {
                "alb.ingress.kubernetes.io/healthcheck-port": std.toString(p.protocol.properties.port), 
                [if p.protocol.type == "http" then "alb.ingress.kubernetes.io/healthcheck-protocol"]: std.asciiUpper(p.protocol.type),
                "alb.ingress.kubernetes.io/backend-protocol": "HTTP", 
                [if p.protocol.type == "http" then "alb.ingress.kubernetes.io/backend-protocol-version"]: "HTTP1", 
                [if p.protocol.type == "grpc" then "alb.ingress.kubernetes.io/backend-protocol-version"]: "GRPC", 
                [if p.protocol.type == "http" then "alb.ingress.kubernetes.io/healthcheck-path"]: p.protocol.properties.path,
                "alb.ingress.kubernetes.io/healthcheck-interval-seconds": std.toString(p.interval_seconds), 
                "alb.ingress.kubernetes.io/healthcheck-timeout-seconds": std.toString(p.timeout_seconds), 
                "alb.ingress.kubernetes.io/healthy-threshold-count": std.toString(p.threshold_success), 
                "alb.ingress.kubernetes.io/unhealthy-threshold-count": std.toString(p.threshold_failure)

            },
        )
     else 
        ing, 

    return: newIng

}