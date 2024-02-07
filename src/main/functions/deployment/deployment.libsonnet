local containerFactory = import "../container/containers.libsonnet"; 
local affinityFactory = import "./affinity.libsonnet"; 
local dnsFactory = import "./dns.libsonnet"; 

function(k, payload, metadata){
    local deployment = k.apps.v1.deployment, 
    local dep = deployment.new(metadata.labels.alias, replicas=0, podLabels=metadata.labels, containers=containerFactory(k, payload, metadata).return) +
    deployment.metadata.withLabels(metadata.labels) + 
    deployment.spec.withRevisionHistoryLimit(4) + 
    deployment.spec.strategy.withType("RollingUpdate") + 
    deployment.spec.strategy.rollingUpdate.withMaxSurge("50%") + 
    deployment.spec.strategy.rollingUpdate.withMaxUnavailable(0) + 
    (if std.get(metadata.opts,"anti_affinity", default=false) then 
        affinityFactory(deployment.spec.template.spec.affinity.podAntiAffinity, payload, metadata).return else {}) +
    (if std.get(metadata.opts, "termination_grace_period_seconds", default=-1) > -1 then 
        deployment.spec.template.spec.withTerminationGracePeriodSeconds(metadata.opts.termination_grace_period_seconds) else {}) + 
    deployment.spec.template.spec.withServiceAccountName(metadata.labels.app) + 
    deployment.spec.template.spec.withNodeSelector({
        "kaas.olxbr.io/workload": metadata.opts.workload,
    }) + 
    (if std.get(metadata.opts, "dns_cache", default=null) != null && std.get(metadata.opts.dns_cache, "enabled", default=true) then 
        dnsFactory(deployment.spec.template.spec, metadata).return else {}), 
    

    return: [dep]
}