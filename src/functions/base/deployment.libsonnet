local containerFactory = import "./container/containers.libsonnet"; 

function(k, payload, metadata){
    local deployment = k.apps.v1.deployment, 

    local dep = deployment.new(metadata.labels.alias, replicas=payload.properties.replicas, podLabels=metadata.labels, containers=containerFactory(k, payload, metadata).return) +
    deployment.metadata.withLabels(metadata.labels) + 
    deployment.spec.withRevisionHistoryLimit(4) + 
    deployment.spec.strategy.withType("RollingUpdate") + 
    deployment.spec.strategy.rollingUpdate.withMaxSurge("50%") + 
    deployment.spec.strategy.rollingUpdate.withMaxUnavailable(0) + 
    (if std.get(payload.properties, "termination_timeout_seconds", default=-1) > -1 then 
        deployment.spec.template.spec.withTerminationGracePeriodSeconds(payload.properties.termination_timeout_seconds) else {}) + 
    deployment.spec.template.spec.withServiceAccountName(metadata.labels.app) +  
    deployment.spec.template.spec.withNodeSelector({
        "kaas.olxbr.io/workload": payload.properties.workload,
    }), 
    

    return: dep
}