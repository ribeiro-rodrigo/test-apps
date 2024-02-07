function(spec, metadata) {

    local baseOptions = [
        { name: "ndots", value: "2" },
        { name: "edns0" },
    ],

    local options = if std.get(metadata.opts.dns_cache, "force_tcp", default=false) then baseOptions + [{name: "use-vc"}] else baseOptions,

    return: spec.withDnsPolicy("None") + 
            spec.dnsConfig.withNameservers(["169.254.20.10"]) + 
            spec.dnsConfig.withSearches(["cluster.local"]) + 
            spec.dnsConfig.withOptions(options), 

}