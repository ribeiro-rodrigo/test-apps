function(k, payload, metadata){
    local sa = k.core.v1.serviceAccount, 
    
    return: sa.new(metadata.labels.app) + 
            sa.withAutomountServiceAccountToken(false) + 
            sa.metadata.withLabels(metadata.labels)
}