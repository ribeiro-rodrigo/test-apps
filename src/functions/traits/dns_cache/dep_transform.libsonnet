function(k, deployment, trait, payload, metadata) {

    local spec = k.apps.v1.deployment.spec.template.spec, 

    local baseOptions = [
        { name: "ndots", value: "2" },
        { name: "edns0" },
    ],

    local options = if std.get(trait.properties, "force_tcp", default=false) then baseOptions + [{name: "use-vc"}] else baseOptions,

    return: deployment + spec.withDnsPolicy("None") + 
            spec.dnsConfig.withNameservers(["169.254.20.10"]) + 
            spec.dnsConfig.withSearches(["cluster.local"]) + 
            spec.dnsConfig.withOptions(options), 

}