import YAML
import Base.+
struct Ensemble{T <: AbstractForce}
    nsample :: Integer
    force :: T
    heun :: Heun
    initlist :: Vector{<:AbstractFloat}
    configurations :: Vector{Configuration}
end

function +(e1::Ensemble{T}, e2::Ensemble{T}) where T
    @assert e1.force == e2.force
    @assert e1.heun == e2.heun
    Ensemble(
        e1.nsample + e2.nsample,
        e1.force,
        e1.heun,
        [e1.initlist; e2.initlist],
        [e1.configurations; e2.configurations]
    )
end

function load_ens(files::Vector{String})::Ensemble
    sum(load_configuration(f) for f in files)
end

function workheatlist(ens::Ensemble)
    worklist = [conf.workheat.work for conf in ens.configurations]
    heatlist = [conf.workheat.heat for conf in ens.configurations]
    return worklist, heatlist
end

function erasure_rate end

function erasure_rate(ens::Ensemble)::Real
    endlist = [lastx(conf.traj) for conf in ens.configurations]
    erased_num = (x->erased(ens.force, x)).(endlist) |> sum
    erased_num / ens.nsample
end

function loadparas(filename="para.yml")
    paras = nothing
    open(filename) do file
        paras = YAML.load(file)
    end
    paras
end