local dnsCacheDepTransform = import "./dns_cache/dep_transform.libsonnet";
local customMetricsDepTransform = import "./custom_metrics/dep_transform.libsonnet"; 
local hpaFactory = import "./autoscaling/hpa.libsonnet"; 

local serviceIngressFactory = import "./ingress/service.libsonnet"; 
local ingressFactory = import "./ingress/ingress.libsonnet"; 
local ingressDepTransform = import "./ingress/dep_transform.libsonnet"; 

local healthcheckIngTransform = import "./healthcheck/ing_transform.libsonnet"; 
local healthcheckDepTransform = import "./healthcheck/dep_transform.libsonnet"; 

local corsIngTransform = import "./cors/ing_transform.libsonnet"; 

local roleSAFactory = import "./role/sa_transform.libsonnet"; 

local antiAffinityDepTransform = import "./anti_affinity/dep_transform.libsonnet";

local ingressClassifierIngTransform = import "./ingress_classifier/ing_transform.libsonnet";


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
            {
                name: "healthcheck", 
                func: healthcheckDepTransform
            },
            {
                name: "anti_affinity", 
                func: antiAffinityDepTransform
            },
        ],
        Ingress:[
            {
                name: "healthcheck", 
                func: healthcheckIngTransform
            },
            {
                name: "cors", 
                func: corsIngTransform
            },
            {   
                //TODO - It should always be the last trait on the list 
                name: "ingress_classifier", 
                func: ingressClassifierIngTransform
            },
        ],
        ServiceAccount: [
            {
                name: "role", 
                func: roleSAFactory
            },
        ],
    }, 
    creation: {
        autoscaling: [hpaFactory], 
        ingress: [serviceIngressFactory, ingressFactory]
    },
}