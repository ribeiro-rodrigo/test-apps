function(resources){

    local cpu = std.filter(function(r) r.type == "cpu", resources)[0].properties,
    local memory = std.filter(function(r) r.type == "memory", resources)[0].properties, 

    local cpuRequestMili = if std.type(cpu) == "object" && std.get(cpu, "request", default=null) != null then cpu.request.value else (cpu * 1000) + "m", 
    local cpuRequest = if std.type(cpu) == "object" && std.get(cpu, "request", default=null) != null && std.get(cpu.request, "unit", default=null) != null && cpu.request.unit == "percent" then (cpu.request.value * 10) + "m" else cpuRequestMili,

    local cpuLimitMili = if std.type(cpu) == "object" && std.get(cpu, "limit", default=null) != null then cpu.limit.value else (cpu * 1000) + "m",
    local cpuLimit = if std.type(cpu) == "object" && std.get(cpu, "limit", default=null) != null && std.get(cpu.limit, "unit", default=null) != null && cpu.limit.unit == "percent" then (cpu.limit.value * 10) + "m" else cpuLimitMili, 

    requests: {
        cpu: cpuRequest, 
        memory:  if std.type(memory) == "object" && std.get(memory, "request", default=null) != null then memory.request.value + memory.request.unit else memory + "M", 
    },
    limits: {
        cpu: cpuLimit, 
        memory: if std.type(memory) == "object" && std.get(memory, "limit", default=null) != null then memory.limit.value + memory.limit.unit else memory + "M"
    },
}