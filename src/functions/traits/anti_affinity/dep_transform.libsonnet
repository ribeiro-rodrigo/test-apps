local affinity = import "./funcs/affinity.libsonnet"; 

function(k, deployment, trait, payload, metadata) {
    local dep = k.apps.v1.deployment,
    return: deployment + affinity(dep.spec.template.spec.affinity.podAntiAffinity, payload, metadata).return
}