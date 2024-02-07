function(healthcheck){

    local probe = {
        timeoutSeconds: healthcheck.timeout, 
        initialDelaySeconds: healthcheck.initial_interval, 
        periodSeconds: healthcheck.interval, 
        successThreshold: if std.get(healthcheck, "threshold", default=null) != null then healthcheck.threshold.success else null,
        failureThreshold: if std.get(healthcheck, "threshold", default=null) != null then healthcheck.threshold.failure else null,
        [if healthcheck.type == "command" then "exec"]: {
            command: healthcheck.command 
        },
        [if healthcheck.type == "network" && healthcheck.protocol == "http" then "httpGet"]: {
            schema: "HTTP", 
            path: healthcheck.path, 
            port: healthcheck.port
        },
        [if healthcheck.type == "network" && healthcheck.protocol != "http" then "tcpSocket"]: {
            port: healthcheck.port
        },
    },

    readinessProbe: probe, 
    livenessProbe: probe
}