local deployment = import "../base/deployment.libsonnet"; 
local cronjob = import "../base/cronjob.libsonnet"; 
local pdb = import "../base/pdb.libsonnet"; 
local sa = import "../base/serviceaccount.libsonnet"; 
local es = import "../base/externalsecrets.libsonnet";

function(k, payload, metadata){

    local types = {
        Deployment: [
            deployment, 
            pdb, 
            sa, 
            es, 
        ],
        CronJob: [
            cronjob, 
            sa, 
            es, 
        ],
    },

    return: std.filter(
        function(e) e != {},
        std.map(
            function(m) m(k, payload, metadata).return, 
            types[metadata.workload_type],
        )
    )
}