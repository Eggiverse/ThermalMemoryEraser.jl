import Base:push!, length

mutable struct Trajectory
    t::Vector{<:Real}
    x::Vector{<:Real}
    v::Union{Vector{<:Real}, Nothing}
end
Trajectory(t::Vector{<:Real}, x::Vector{<:Real}) = Trajectory(t, x, nothing)
Trajectory(T::Type) = Trajectory(Vector{T}(), Vector{T}(), nothing)
Trajectory() = Trajectory(Float64)

function push!(tj::Trajectory, t::Real, x::Real)
    push!(tj.t, t)
    push!(tj.x, x)
    tj
end

function genrate_v!(tj::Trajectory)
    tj.v = (tj.x[3:end] - tj.x[1:end-2]) ./ (tj.t[3:end] - tj.t[1:end-2]) 
end

lastx(tj::Trajectory)::Real = tj.x[end]

function length(tj::Trajectory)
    length(tj.x)
end

function heun_fill!(tj::Trajectory, h::Heun, f::Function, trange::Tuple{T, T})::Trajectory where T<:Real
    t0, tend = trange
    for t in t0:h.step:tend
        push!(tj, heun_update(f, h, lastx(tj), t)...)
    end
    tj
end

function heun_fill(x0::Real, h::Heun, f::Function, trange::Tuple{T, T})::Trajectory where T<:Real
    heun_fill!(Trajectory([trange[1]],[x0]), h, f, trange)
end
