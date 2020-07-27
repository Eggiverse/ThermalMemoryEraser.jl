struct SpringForce <: AbstractForce
    A :: Real
end

function potential(f::SpringForce, x::Real, t::Real)::Real 
    - f.A * x^2
end

function virtual_workrate(f::SpringForce, x::Real,v::Real, t::Real)::Real
    total_force(f, x, t) * v
end

function erased(f::SpringForce, x::Real)::Bool
    x < 0
end