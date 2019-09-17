using Flux:Tracker

abstract type AbstractForce end

function potential(f::AbstractForce, x::Real, t::Real)::Real end

function total_force(f::AbstractForce, x::Real, t::Real)::Real
    #@info "You are using AD"
    px = p->potential(f, p, t)
    g = Tracker.gradient(px, x)[1]
    - g.data
end

function virtual_workrate(f::AbstractForce, x::Real, v::Real, t::Real)::Real end

function erased(f::AbstractForce, x::Real)::Bool end
# end