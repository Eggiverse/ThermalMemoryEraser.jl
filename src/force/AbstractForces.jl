import Zygote

abstract type AbstractForce end

function potential(f::AbstractForce, x::Real, t::Real) end

function total_force(f::AbstractForce, x::Real, t::Real)::Real
    @debug "You are using AD"
    px = p->potential(f, p, t)
    g = Zygote.gradient(px, x)[1]
    - g
end

function virtual_workrate(f::AbstractForce, x::Real, v::Real, t::Real)::Real end

function erased(f::AbstractForce, x::Real)::Bool end
# end