local asgGenFunc = import "./funcs/hpa_gen_func.libsonnet"; 
local kedaGenFunc = import "./funcs/keda_gen_func.libsonnet"; 

function(k, trait, payload, metadata){

    local factory = {
        keda: kedaGenFunc, 
        legacy: asgGenFunc, 
    },

    local opt = std.get(metadata.opts.traits, "autoscaling", default={impl: "keda"}), 

    return: factory[opt.impl](k, trait, payload, metadata).return
    
}