
if !isdefined(:__EXPRESSION_HASHES__)
    __EXPRESSION_HASHES__ = Set{UInt64}()
end

macro runonce(expr)
    h = hash(expr)
    return esc(quote
        if !in($h, __EXPRESSION_HASHES__)
            push!(__EXPRESSION_HASHES__, $h)
            $expr
        end
    end)
end


function ccv_type{T}(::Type{T})
    if haskey(JULIA2CCV_TYPE, T)
        return JULIA2CCV_TYPE[T]
    else
        throw(ArgumentError("CCV can't handle Julia's $T type"))
    end
end


function julia_type(ccv_typ::Cuint)
    if haskey(CCV2JULIA_TYPE, ccv_typ)
        return CCV2JULIA_TYPE[ccv_typ]
    else
        throw(ArgumentError("Unknown CCV type with cide $ccv_typ"))
    end
end
