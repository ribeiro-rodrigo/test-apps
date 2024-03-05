function(healthcheck){

    local probe = {
        timeoutSeconds: healthcheck.timeout_seconds, 
        initialDelaySeconds: healthcheck.initial_interval_seconds, 
        periodSeconds: healthcheck.interval_seconds, 
        successThreshold: if std.get(healthcheck, "threshold_success", default=null) != null then healthcheck.threshold_success else null,
        failureThreshold: if std.get(healthcheck, "threshold_failure", default=null) != null then healthcheck.threshold_failure else null,
        [if healthcheck.protocol.type == "command" then "exec"]: {
            command: healthcheck.protocol.properties.command 
        },
        [if healthcheck.protocol.type == "http" then "httpGet"]: {
            scheme: "HTTP", 
            path: healthcheck.protocol.properties.path, 
            port: healthcheck.protocol.properties.port
        },
        [if healthcheck.protocol.type == "grpc" then "grpc"]: {
            port:  healthcheck.protocol.properties.port
        },
        [if healthcheck.protocol.type == "tcp" then "tcpSocket"]: {
            port: healthcheck.protocol.properties.port
        },
    },

    readinessProbe: probe, 
    livenessProbe: probe + {successThreshold+: 1},
}