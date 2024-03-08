function(k, trait, payload, metadata){
    local hpa = k.autoscaling.v2.horizontalPodAutoscaler, 

    return: 
        [
            hpa.new(metadata.labels.app) + 
            hpa.metadata.withLabels(metadata.labels) + 
            hpa.spec.withScaleTargetRef({kind: "Deployment", metadata: {name: metadata.labels.app}, apiVersion: "apps/v1"}) + 
            hpa.spec.withMinReplicas(trait.properties.min) + 
            hpa.spec.withMaxReplicas(trait.properties.max) + 
            hpa.spec.withMetrics([
                {
                    type: "Resource", 
                    resource: {
                        name: "memory", 
                        target: {
                            type: "Utilization", 
                            averageUtilization: trait.properties.threshold_memory_value
                        },
                    } 
                },
                {
                    type: "Resource", 
                    resource: {
                        name: "cpu", 
                        target: {
                            type: "Utilization", 
                            averageUtilization: trait.properties.threshold_cpu_value
                        },
                    }
                }
            ])
        ]
    
}