# COPS APPS

Repository intended for GitOps integration between COPS and ArgoCD. 

## Example

Example of an Application manifest created by the COPS API

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application 
metadata:
  name: cops-app
  namespace: argocd 
spec:
  destination:
    namespace: [namespace] 
    server: "https://kubernetes.default.svc"
  project: [project] 
  source:
    path: src/main/web
    repoURL: "https://github.com/olxbr/cops-apps.git"
    targetRevision: master 
    directory:
      jsonnet:
        tlas:
          - name: payload
            code: true
            value: |
                {
                    "type": "webapp",
                    "properties": {
                        "image": {
                            "address": "nginx:latest", 
                            "pull_always": false 
                        },
                        "command": "sleep 300", 
                        "replicas": 1,
                        "termination_timeout_seconds": 60,  
                        "disruption_budget": "60%", 
                        "workload": "compute", 
                        "resources":[
                            {
                                "type": "cpu", 
                                "properties": {
                                    "limit": {
                                        "value": 10, 
                                        "unit": "percent"
                                    }, 
                                    "request" : {
                                        "value": 5, 
                                        "unit": "percent"
                                    }
                                }
                            }, 
                            {
                                "type": "memory", 
                                "properties": {
                                    "limit": {
                                        "value": "250", 
                                        "unit": "M"
                                    }, 
                                    "request": {
                                        "value": "100", 
                                        "unit": "M"
                                    }
                                }
                            }
                        ], 
                        "environments": [
                            {
                                "type": "secret",
                                "properties": {
                                    "name": "DB_HOST",
                                    "value": "db.example.com"
                                }
                            }
                        ]
                    },
                    "traits": [
                        {
                            "type": "autoscaling", 
                            "properties": {
                                "min": 2, 
                                "max": 2, 
                                "threshold_cpu_unit": "percent", 
                                "threshold_cpu_value": 80, 
                                "threshold_memory_unit": "percent", 
                                "threshold_memory_value": 80, 
                                "polling_interval": 30,
                                "cooldown_period": 300,
                                "fallback_enabled": false, 
                                "failure_threshold": 3
                            }
                        }, 
                        {
                            "type": "kafka-autoscaling", 
                            "properties": {
                                "brokers": [], 
                                "consumer_group":"",
                                "topic":"",
                                "lag_threshold":"5",
                                "offset_reset_policy":"latest",
                                "allow_idle_consumers":false,
                                "exclude_persistent_lag":false,
                                "version":"1.0.0",
                                "partition_limitation":[], 
                                "polling_interval": 30,
                                "cooldown_period": 300,
                                "fallback_enabled": false, 
                                "failure_threshold": 3
                            }
                        }, 
                        {
                            "type": "ingress",
                            "properties": {
                                "class": "alb", 
                                "private": { 
                                    "endpoints": [
                                        {
                                            "type": "http", 
                                            "properties": {
                                                "host": "testmginxcopsapps",
                                                "port": 80, 
                                                "domain": "olxbr.cloud",
                                                "path": "/teste"
                                            }
                                        }, 
                                        {
                                            "type": "http", 
                                            "properties": {
                                                "host": "testmginxcopsapps",
                                                "port": 8080, 
                                                "domain": "olxbr.cloud",
                                                "path": "/health"
                                            }
                                        }, 
                                        {
                                            "type": "grpc", 
                                            "properties": {
                                                "host": "grpc-testmginxcopsapps",
                                                "port": 5646, 
                                                "domain": "olxbr.cloud"
                                            }
                                        } 
                                    ]
                                }, 
                                "public": {
                                    "endpoints": [
                                        {
                                            "type": "http", 
                                            "properties": {
                                                "host": "mypublic",
                                                "port": 80, 
                                                "domain": "olx.com.br",
                                                "path": "/"
                                            }
                                        }
                                    ]
                                } 
                            }
                        }, 
                        {
                            "type": "cors", 
                            "properties": {
                                "allow_credentials": true,
                                "allowed_headers": [
                                "DNT",
                                "Keep-Alive",
                                "User-Agent",
                                "X-Requested-With",
                                "If-Modified-Since",
                                "Cache-Control",
                                "Content-Type",
                                "Range",
                                "Authorization"
                                ],
                                "allowed_methods": [
                                "GET",
                                "PUT",
                                "POST",
                                "DELETE",
                                "PATCH",
                                "OPTIONS"
                                ],
                                "allowed_origins": [
                                ""
                                ],
                                "expose_headers": [],
                                "max_age": 1728000 
                            }
                        }, 
                        {
                            "type": "custom_metrics", 
                            "properties": {
                                "port": 80,
                                "path": "/metrics"  
                            }
                        }, 
                        {
                            "type": "healthcheck", 
                            "properties": {
                                "initial_interval_seconds": 10, 
                                "internal_seconds": 30, 
                                "timeout_seconds": 3, 
                                "threshold_failure": 2, 
                                "threshold_success": 1, 
                                "protocol": {
                                    "type": "http", 
                                    "properties": {
                                        "path": "/healthcheck", 
                                        "timeout": 3
                                    }
                                }
                            }
                        }, 
                        {
                            "type": "dns_cache", 
                            "properties": {
                                "force_tcp": true 
                            }
                        }
                    ]   
                }

          - name: metadata
            code: true
            value: |
                {
                    "labels": {
                        "cluster": "prod-cops-1", 
                        "namespace": "foundation", 
                        "app": "calopsita", 
                        "alias": "app-01"
                    }, 
                    "internal_host_domain": "cops.olxbr.cloud", 
                }
        libs:
          - vendor
  syncPolicy:
    syncOptions: 
      - CreateNamespace=true  
```