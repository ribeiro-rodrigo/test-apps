function(k, payload, metadata){
    local sa = k.core.v1.serviceAccount, 
    
    return: sa.new(metadata.labels.app) + 
            sa.withAutomountServiceAccountToken(false) + 
            sa.metadata.withLabels(metadata.labels) + 
            (if std.get(metadata.opts, "assume_role", default=null) != null then sa.metadata.withAnnotations({
                "eks.amazonaws.com/role-arn": metadata.opts.assume_role
            }) else {})
}