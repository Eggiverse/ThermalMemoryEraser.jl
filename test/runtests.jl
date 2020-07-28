using ThermalMemoryEraser
using Test
import ThermalMemoryEraser: potential, virtual_workrate, erased

include("spring_force.jl")

function multi_ensemble()

    nsample = 2
    T = 1.0
    dt = 1.e-2
    τ = 1.0
    f = SpringForce(1.0)

    h = Heun(step=dt, temperature=T)

    init = [10.0, 5.0]

    configurations = [Configuration(x, f, h, τ) for x in init]

    Ensemble(nsample, f, h, init, configurations)
end

function main()
    ens = multi_ensemble()

    er = erasure_rate(ens)
    @info "error rate" er

    w, q = workheatlist(ens)
    @info work=w, heat=q
    @test w !== nothing
    @test q !== nothing
end

@test potential(SpringForce(1), 1, 0.2) !== nothing

main()