module Configurations

import JLD2

using ..Trajectories
using ..Metrics
using ..Force
using ..UpdateMethods

export Configuration

struct Configuration
    traj :: Trajectory
    workheat :: WorkHeat
end

function Configuration(x0::Real, f::AbstractForce, h::Heun)
    t0 = 0.0
    traj = heun_fill(x0, h, (p, t) -> total_force(f, p, t), (t0, f.τ_all))
    workheat = get_workheat(traj, f, h.step)
    Configuration(traj, workheat)
end

function save_configuration(conf::Configuration, filename)
    @JLD2.save filename conf
end

function load_configuration(filename)::Configuration
    @JLD2.load filename conf
    return conf    
end

end
