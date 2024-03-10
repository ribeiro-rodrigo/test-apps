function(k, trait, payload, metadata){
    local hpa = k.autoscaling.v2.horizontalPodAutoscaler, 

    return: 
        [
            hpa.new(metadata.labels.app) + 
            hpa.metadata.withLabels(metadata.labels) + 
            hpa.spec.withScaleTargetRef({kind: "Deployment", metadata: {name: metadata.labels.app}, apiVersion: "apps/v1"}) + 
            hpa.spec.withMinReplicas(trait.properties.min) + 
            hpa.spec.withMaxReplicas(trait.properties.max) + 
            hpa.spec.withMetrics(
                std.filterMap(
                    function(e) 
                        e.type == "cpu_utilization" || e.type == "memory_utilization", 
                    function(e)
                        {
                            type: "Resource", 
                            resource: {
                                name: std.strReplace(e.type, "_utilization", ""), 
                                target: {
                                    type: "Utilization",
                                    [if e.type == "cpu_utilization" then "averageUtilization"]: e.properties.threshold_cpu_value,
                                    [if e.type == "memory_utilization" then "averageUtilization"]: e.properties.threshold_memory_value
                                },
                            },
                        },
                        trait.properties.policies
                ) 
            )
        ]
    
}