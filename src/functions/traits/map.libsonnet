local dnsCacheDepTransform = import "./dns_cache/dep_transform.libsonnet";
local customMetricsDepTransform = import "./custom_metrics/dep_transform.libsonnet"; 

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
        ],
    }, 
    creation: {},
}