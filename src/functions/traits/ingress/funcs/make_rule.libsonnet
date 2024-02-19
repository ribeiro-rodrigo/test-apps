function(ingress, hosts, endpoints, metadata)
        ingress.spec.withRules([
            {
                host: host, 
                http: {
                    paths: [
                        {
                            backend: {
                                service: {
                                    name: "ing-" + metadata.labels.app, 
                                    port: {
                                        number: e.properties.port
                                    },
                                },
                            },
                            path: if e.type == "grpc" then "/*" else e.properties.path, 
                            pathType: "ImplementationSpecific"
                        },
                    for e in std.filter(function(e) (e.properties.host + "." + e.properties.domain) == host, endpoints)],
                },
            }
            for host in hosts
        ])
