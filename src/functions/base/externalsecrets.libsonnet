function(k, payload, metadata){

    local secrets = std.filter(
        function(env) env.type == "secret", 
        payload.properties.environments
    ), 

    return: if secrets != [] then {
        apiVersion: "kubernetes-client.io/v1", 
        kind: "ExternalSecret", 
        metadata: {
            name: "es-" + metadata.labels.app, 
            labels: metadata.labels
        },
        spec: {
            backendType: "vault", 
            vaultRole: "cops", 
            kvVersion: 2, 
            vaultMountPoint: metadata.labels.cluster, 
            data: std.map(
                function(secret) {
                    key: metadata.team.squad_uuid + "/data/cops/" + metadata.team.workspace_uuid + "/" + metadata.labels.app,
                    name: secret.properties.name, 
                    property: secret.properties.name
                },
                secrets
            )
        },
    } else {},
}