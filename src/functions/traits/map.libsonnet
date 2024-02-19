local dnsCacheDepTransform = import "./dns_cache/dep_transform.libsonnet";
local customMetricsDepTransform = import "./custom_metrics/dep_transform.libsonnet"; 
local hpaFactory = import "./autoscaling/hpa.libsonnet"; 

local serviceIngressFactory = import "./ingress/service.libsonnet"; 
local ingressFactory = import "./ingress/ingress.libsonnet"; 
local ingressDepTransform = import "./ingress/dep_transform.libsonnet"; 

function(){
    transform: {
        Deployment:[
            {
                name: "dns_cache", 
                func: dnsCacheDepTransform
            }, 
            {
                name: "custom_metrics", 
                func: customMetricsDepTransform
            },
            {
                name: "ingress", 
                func: ingressDepTransform
            },
        ],
    }, 
    creation: {
        autoscaling: [hpaFactory], 
        ingress: [serviceIngressFactory, ingressFactory]
    },
}