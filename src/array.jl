
@runonce immutable CCVArrayType{T}
    typ::Cint
    sig::UInt64
    refcount::Cint
    rnum::Cint
    size::Cint
    rsize::Cint
    data::Ptr{T}
end


@runonce type CCVArray{T}
    ptr::Ptr{CCVArrayType{T}}
    function CCVArray(ptr::Ptr{CCVArrayType{T}})
        arr = new(ptr)
        finalizer(arr, arr -> free(arr))
        arr
    end
end


function free(arr::CCVArray)
    if arr.ptr != C_NULL
        ccall((:ccv_array_free, libccv), Void, (Ptr{CCVArrayType},), arr)
        arr.ptr = C_NULL
    end
end


function Base.getindex{T}(arr::CCVArray{T}, i::Integer)
    at = unsafe_load(arr.ptr)
    if i <= at.rnum
        return unsafe_load(at.data, i)
    else
        throw(BoundsError("Index $i is greater than " *
                          "array length $(at.rnum)"))
    end
end


function Base.length(arr::CCVArray)
    at = unsafe_load(arr.ptr)
    return at.rnum
end
Base.size(arr::CCVArray) = (length(arr),)


Base.cconvert{T}(::Type{Ptr{CCVArrayType{T}}}, arr::CCVArray{T}) = arr
Base.unsafe_convert{T}(::Type{Ptr{CCVArrayType{T}}}, arr::CCVArray{T}) = arr.ptr

