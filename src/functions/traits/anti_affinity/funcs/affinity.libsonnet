function(affinity, payload, metadata){
    return: affinity.withPreferredDuringSchedulingIgnoredDuringExecution({
        weight: 1,
        podAffinityTerm: {
            labelSelector: {
                matchExpressions: [
                    {
                        key: "app",
                        operator: "In",
                        values: [metadata.labels.app] 
                    },
                ],
            },
            topologyKey: "kubernetes.io/hostname"
        },
    }) + 
    affinity.withRequiredDuringSchedulingIgnoredDuringExecution([
        {
            labelSelector: {
                matchExpressions: [
                    {
                        key: "app",
                        operator: "In",
                        values: [metadata.labels.app]
                    },
                ],
            },
            topologyKey: "kubernetes.io/hostname",
        },
    ])
}