function(uuid, environments){
    local envs = [   
        {
            name: env.name, 
            [if env.type == "value" then "value"]: env.value, 
            [if env.type == "secret" then "valueFrom"]: {
                secretKeyRef: {
                    name: "es-"+uuid, 
                    key: env.name 
                },
            },
        }

        for env in environments
    ], 

    return: envs 
}