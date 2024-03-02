function(k, payload, metadata){
    local pdb = k.policy.v1.podDisruptionBudget, 

    return: pdb.new("pdb-"+metadata.labels.app) + 
            pdb.metadata.withLabels(metadata.labels) + 
            pdb.spec.withMinAvailable(std.get(payload.properties, "disruption_budget", default="50%")) + 
            pdb.spec.selector.withMatchLabels({app: metadata.labels.app})
}