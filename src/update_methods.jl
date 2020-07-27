module UpdateMethods

export Heun, heun_update

struct Heun
    temppara::Real
    step::Real
end

Heun(;step, temperature) = Heun(√(2 *temperature*step), step)

function heun_update(forcefunc::Function, temppara::Real, step::Real, y::Real, t::Real)::Tuple{Real, Real}
    w = randn() * temppara
    c1 = forcefunc(y,t)
    c2 = forcefunc(y+c1*step+w,t+step)
    yn = y+step/2.0*(c1+c2)+w
    return t+step, yn
end

heun_update(f::Function, h::Heun, y::Real, t::Real)::Tuple{Real, Real} = heun_update(f, h.temppara, h.step, y, t)

end
