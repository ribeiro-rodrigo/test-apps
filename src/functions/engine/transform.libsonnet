local traits = import "../traits/map.libsonnet"; 

function(manifests, k, payload, metadata){
    local map = traits(), 

    return: std.map(
        function(m) 
            if std.get(map.transform, m.kind, default=[]) != [] then 
                std.foldl(
                    function(v, o) o.object.func(k, v, o.trait, payload, metadata).return, 
                        std.filterMap(
                            function(ob) 
                                std.count(
                                    std.map(function(t) t.type, payload.traits), ob.name
                                ) > 0, 
                            function(ob){
                                object: ob, 
                                trait: std.filter(function(t) t.type == ob.name, payload.traits)[0],
                            },
                            map.transform[m.kind]
                        ),  
                    m,
                ) 
            else m, 
        manifests
    ),  
}