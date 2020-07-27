module Metrics

using ..Trajectories
using ..Trajectories:genrate_v!
using ..Force

export WorkHeat, get_workheat

mutable struct WorkHeat
    work::Real
    heat::Real
end

function get_workheat(tj::Trajectory, workrate::Function, potential::Function, step::Real)::WorkHeat
    if isnothing(tj.v)
        genrate_v!(tj)
    end
    work = sum(workrate.(tj.x[2:end-1], tj.v, tj.t[2:end-1])) * step
    dp = potential(tj.x[end-1], tj.t[end-1]) - potential(tj.x[2], tj.t[2])
    heat = work - dp
    WorkHeat(work, heat)
end

function get_workheat(tj::Trajectory, f::AbstractForce, step::Real)::WorkHeat
    get_workheat(tj, 
                 (x, v, t) -> virtual_workrate(f, x, v, t),
                 (x, t) -> potential(f, x, t),
                 step
                )
end

end