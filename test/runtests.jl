using ThermalMemoryEraser

include("spring_force.jl")

function multi_ensemble()

    nsample = 2
    T = 1.0
    dt = 1.e-2
    τ = 1
    f = SpringForce(1.0)

    h = Heun(step=dt, temperature=T)

    init = 10.0

    configurations = [Configuration(x, f, h) for x in init]

    Ensemble(nsample, f, h, init, configurations)
end

"""
主函数，产生一个系综并获取功热和轨迹信息
"""
function main()
    ens = multi_ensemble()

    er = erasure_rate(ens)
    @info "error rate" er
end