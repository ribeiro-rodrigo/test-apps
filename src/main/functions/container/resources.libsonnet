function(container){
    local cpu = container.cpu,   
    local memory = container.memory, 

    local cpuLimitMili = if std.type(cpu) == "object" && std.get(cpu, "limit", default=null) != null then cpu.limit.value else (cpu * 1000) + "m",
    local cpuLimit = if std.type(cpu) == "object" && std.get(cpu, "limit", default=null) != null && std.get(cpu.limit, "unit", default=null) != null && cpu.limit.unit == "percent" then (cpu.limit.value * 10) + "m" else cpuLimitMili, 

    local cpuRequestMili = if std.type(cpu) == "object" && std.get(cpu, "reservation", default=null) != null then cpu.reservation.value else (cpu * 1000) + "m", 
    local cpuRequest = if std.type(cpu) == "object" && std.get(cpu, "reservation", default=null) != null && std.get(cpu.reservation, "unit", default=null) != null && cpu.reservation.unit == "percent" then (cpu.reservation.value * 10) + "m" else cpuRequestMili, 


    limits: {
        cpu: cpuLimit, 
        memory: if std.type(memory) == "object" && std.get(memory, "limit", default=null) != null then memory.limit.value + memory.limit.unit else memory + "M"
    },
    requests: {
        memory: if std.type(memory) == "object" && std.get(memory, "reservation", default=null) != null then memory.reservation.value + memory.reservation.unit else memory + "M", 
        cpu: cpuRequest
    },
}