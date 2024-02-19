function(trait)
    std.set(trait.properties.private.endpoints + trait.properties.public.endpoints, keyF=function(x)x.properties.port)