function(k, deployment, trait, payload, metadata){
    local dep = k.apps.v1.deployment, 

    return: deployment + dep.spec.template.metadata.withAnnotations({
        "prometheus.io/scrape": 'true', 
        "prometheus.io/port": std.toString(trait.properties.port), 
        "prometheus.io/path": trait.properties.path,
    })
}