function(k, ing, trait, payload, metadata) {
    local ingress = k.networking.v1.ingress,
    local p = trait.properties, 

    local newIng = if ing.spec.ingressClassName == "alb" && (p.protocol.type == "http" || p.protocol.type == "grpc") then 
        ing + ingress.metadata.withAnnotations(
            ing.metadata.annotations + 
            {
                "alb.ingress.kubernetes.io/healthcheck-port": p.protocol.properties.port, 
                "alb.ingress.kubernetes.io/healthcheck-protocol": p.protocol.type, 
                [if p.protocol.type == "http" then "alb.ingress.kubernetes.io/healthcheck-path"]: p.protocol.properties.path,
                "alb.ingress.kubernetes.io/healthcheck-interval-seconds": p.interval_seconds, 
                "alb.ingress.kubernetes.io/healthcheck-timeout-seconds": p.timeout_seconds, 
                "alb.ingress.kubernetes.io/healthy-threshold-count": p.threshold_success, 
                "alb.ingress.kubernetes.io/unhealthy-threshold-count": p.threshold_failure

            },
        )
     else 
        ing, 

    return: newIng

}