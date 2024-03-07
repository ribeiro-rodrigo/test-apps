function(k, ing, trait, payload, metadata){
    local tier = std.get(ing.metadata.annotations, "alb.ingress.kubernetes.io/scheme", default=null), 
    
    return: if ing.spec.ingressClassName != "alb" || tier == null  
        then ing else 
        {
            apiVersion: "cops.olxbr.cloud/v1alpha1", 
            kind: "HorizontalALBAutoscaler", 
            metadata: {
                name: "haa-" + metadata.labels.app
            },
            spec: {
                class: if tier != "internal" then "external" + trait.properties.class else tier + trait.properties.class, 
                cluster: metadata.labels.cluster, 
                template: {
                    metadata: ing.metadata, 
                    spec: ing.spec
                },
            },
        },
}