function(uuid, environments){
    local envs = [   
        {
            name: env.properties.name, 
            [if env.type == "value" then "value"]: env.properties.value, 
            [if env.type == "secret" then "valueFrom"]: {
                secretKeyRef: {
                    name: "es-"+uuid, 
                    key: env.properties.name 
                },
            },
        }

        for env in environments
    ], 

    return: envs 
}