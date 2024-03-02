local healthcheck_gen = import "./funcs/gen_dep_healthcheck.libsonnet"; 


function(k, dep, trait, payload, metadata) {

    local container = k.core.v1.container, 
    local deployment = k.apps.v1.deployment,

    local c = dep.spec.template.spec.containers[0],

    local newC = c + healthcheck_gen(trait.properties), 

    return: dep + deployment.spec.template.spec.withContainers([newC])


}