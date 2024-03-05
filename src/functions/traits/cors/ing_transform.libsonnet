function(k, ing, trait, payload, metadata) {
    local ingress = k.networking.v1.ingress,
    local p = trait.properties, 

    local newIng = if ing.spec.ingressClassName == "nginx" then 
        ing + ingress.metadata.withAnnotations(
            ing.metadata.annotations + 
            {
                "nginx.ingress.kubernetes.io/enable-cors": 'true', 
                "nginx.ingress.kubernetes.io/cors-allow-methods": std.join(",", p.allowed_methods), 
                "nginx.ingress.kubernetes.io/cors-allow-headers": std.join(",", p.allowed_headers),
                "nginx.ingress.kubernetes.io/cors-max-age": p.max_age, 
                "nginx.ingress.kubernetes.io/cors-expose-headers": std.join(",", p.expose_headers),
                "nginx.ingress.kubernetes.io/cors-allow-credentials": std.toString(p.allowed_credentials), 
                "nginx.ingress.kubernetes.io/cors-allow-origin": std.join(",", p.allowed_origins),

            },
        )
     else 
        ing, 

    return: newIng

}