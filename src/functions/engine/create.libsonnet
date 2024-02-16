local traitsMap = import "../traits/map.libsonnet"; 

function(k, payload, metadata){
    local map = traitsMap(), 

    return: std.filterMap(
        function(trait) 
            std.get(map.creation, trait.type, default=null) != null, 
        function(trait) 
            map.creation[trait.type](k, trait, payload, metadata).return,
        payload.traits
    )
}
