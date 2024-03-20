function(){
    cpu_utilization: function(policy, metadata){
        return: {
                    type: "cpu", 
                    metricType: "Utilization", 
                    metadata: {
                        value: std.toString(policy.properties.threshold_cpu_value)
                    }
                },
    },

    memory_utilization: function(policy, metadata){
        return: {
                    type: "memory", 
                    metricType: "Utilization", 
                    metadata: {
                        value: std.toString(policy.properties.threshold_memory_value)
                    }
                },
    },

    kafka: function(policy, metadata){
        local this = metadata.opts.traits, 
        local defaultOpts = std.get(this, "autoscaling", default={
            lag_threshold: std.get(this.autoscaling, "default_kafka_lag_threshold", default=10), 
            offset_reset_policy: std.get(this.autoscaling, "default_kafka_offset_reset_policy", default=15), 
            exclude_persistent_lag: std.get(this.autoscaling, "default_kafka_exclude_persistent_lag", default=false), 
            allow_idle_consumers: std.get(this.autoscaling, "default_allow_idle_consumers", default=false)
        }),

        return: {
            type: "kafka", 
            metadata: {
                allowIdleConsumers: std.get(policy.properties, "allow_idle_consumers", default=defaultOpts.allowIdleConsumers), 
                bootstrapServers: std.join(",", policy.properties.brokers), 
                consumerGroup: policy.properties.consumer_group, 
                excludePersistentLag: std.get(policy.properties, "exclude_persistent_lag", default=defaultOpts.allow_idle_consumers), 
                lagThreshold: std.get(policy.properties, "lag_threshold", default=defaultOpts.lag_threshold), 
                offsetResetPolicy: std.get(policy.properties, "offset_reset_policy", default=defaultOpts.offset_reset_policy), 
                topic: policy.properties.topic 
            },
        },
    },
}
