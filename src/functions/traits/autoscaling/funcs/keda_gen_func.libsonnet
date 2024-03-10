local all_policies_factory = import "./policies_gen.libsonnet"; 

function(k, trait, payload, metadata){
    local p = trait.properties, 
    local opts = std.get(metadata.opts, "autoscaling", default={}), 
    local all_policies = all_policies_factory(), 

    return: [
        {   
            apiVersion: "keda.sh/v1alpha1", 
            kind: "ScaledObject", 
            metadata: {
                name: metadata.labels.alias + "-scaled-object", 
                annotations: {
                    "autoscaling.keda.sh/paused": null,
                },
            },
            spec: {
                maxReplicaCount: p.max, 
                minReplicaCount: p.min, 
                cooldownPeriod: p.cooldown_period, 
                pollingInterval: p.polling_interval, 
                fallback:{
                    failureThreshold: std.get(opts, "fallback_failure_threshold", default=3), 
                    replicas: std.get(opts, "fallback_replicas", default=p.min)
                },
                scaleTargetRef: {
                    kind: "Deployment", 
                    name: metadata.labels.app
                },
                triggers: [
                    all_policies[policy.type](policy, metadata).return,
                    for policy in p.policies
                ],
            },
        },
    ]
}