local traitsMap = import "../traits/map.libsonnet"; 

function(k, payload, metadata){
    local map = traitsMap(), 

    return: std.flattenArrays(std.filterMap(
        function(trait) 
            std.get(map.creation, trait.type, default=null) != null, 
        function(trait) 
            std.flattenArrays([f(k, trait, payload, metadata).return for f in map.creation[trait.type]]),
        payload.properties.traits
    ))
}
