local containerFactory = import "./container/containers.libsonnet"; 

function(k, payload, metadata){
    local cronjob = k.batch.v1.cronJob, 

    return: cronjob.new(
        metadata.labels.alias, 
        payload.properties.cron, 
        containers=containerFactory(k, payload, metadata).return
    ) 
    + cronjob.metadata.withLabels(metadata.labels) 
    + cronjob.spec.withConcurrencyPolicy(payload.properties.concurrencyPolicy)
    + cronjob.spec.withFailedJobsHistoryLimit(30)
    + cronjob.spec.withStartingDeadlineSeconds(payload.properties.startingDeadlineSeconds)
    + cronjob.spec.withSuccessfulJobsHistoryLimit(30)
    + cronjob.spec.withSuspend(payload.properties.suspended)
    + cronjob.spec.jobTemplate.spec.withSuspend(payload.properties.suspended)
    + cronjob.spec.jobTemplate.spec.withBackoffLimit(payload.properties.maxRetries)
    + cronjob.spec.jobTemplate.spec.template.metadata.withLabels(metadata.labels)
    + cronjob.spec.jobTemplate.spec.template.metadata.withAnnotations(
        {"cops.olxbr.cloud/owner": "true"}
    )
    + cronjob.spec.jobTemplate.spec.template.spec.withAutomountServiceAccountToken(false)
    + cronjob.spec.jobTemplate.spec.template.spec.withRestartPolicy("Never")
    + cronjob.spec.jobTemplate.spec.template.spec.withServiceAccountName(metadata.labels.app)
}