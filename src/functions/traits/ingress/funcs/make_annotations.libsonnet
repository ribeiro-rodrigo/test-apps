function(protocol, class, tier, metadata){
    local annotations = {
        all: {
            "external-dns.alpha.kubernetes.io/aws-weight": "100",
            "external-dns.alpha.kubernetes.io/set-identifier": metadata.labels.cluster,
            "external-dns.alpha.kubernetes.io/hostname": "internal-" + metadata.labels.app + "" + metadata.internal_host_domain,
            "external-dns.alpha.kubernetes.io/ingress-hostname-source": "annotation-only",
        },
        nginx: {
            "kubernetes.io/tls-acme": "true", 
            "prometheus.io/probe": "true",
        },
        alb: {
            "alb.ingress.kubernetes.io/target-type": "ip",
            "alb.ingress.kubernetes.io/backend-protocol": "HTTP",
            "alb.ingress.kubernetes.io/backend-protocol-version": if protocol == "http" then "HTTP1" else protocol,
            "alb.ingress.kubernetes.io/success-codes": if protocol == "GRPC" then "0-99" else "200-399",
            "alb.ingress.kubernetes.io/scheme": if tier == "private" then "internal" else "internet-facing",
            "alb.ingress.kubernetes.io/target-group-attributes": "deregistration_delay.timeout_seconds=60",
            "alb.ingress.kubernetes.io/load-balancer-attributes": "idle_timeout.timeout_seconds=60",
            "alb.ingress.kubernetes.io/listen-ports": '[{"HTTPS": 443}]',
        },
    },

    return: annotations["all"] + annotations[class],
}