local makeRules = import "./funcs/make_rule.libsonnet";
local makeAnnotations = import "./funcs/make_annotations.libsonnet";  
local ingresGenerator = import "./funcs/ingress_gen_func.libsonnet"; 

function(k, trait, payload, metadata){

    local ingress = k.networking.v1.ingress, 

    local privateIngress = ingresGenerator(
        ingress, 
        "private", 
        trait.properties.class, 
        trait.properties.private.endpoints, 
        metadata
    ).return, 

    local publicIngress = ingresGenerator(
        ingress, 
        "public", 
        trait.properties.class, 
        trait.properties.public.endpoints, 
        metadata
    ).return, 

    return: privateIngress + publicIngress

}