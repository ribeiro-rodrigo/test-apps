function(k, serviceAccount, trait, payload, metadata){
    local sa = k.core.v1.serviceAccount, 

    return: serviceAccount + sa.metadata.withAnnotations(
        std.get(serviceAccount.metadata, "annotations", {}) + {
            "eks.amazonaws.com/role-arn": trait.properties.arn, 
        },
    )
}