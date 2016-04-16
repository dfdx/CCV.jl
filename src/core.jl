
const libccv = Pkg.dir("CCV", "deps", "ccv", "lib", "libccv.so")

include("const.jl")


# typealias CCVDenseMatrix Ptr{Void}


type CCVDenseMatrix <: AbstractArray{Float64,2}
    dtype::Cint
    sig::UInt64
    refcount::Cint
    rows::Cint
    cols::Cint
    step::Cint
    tag::Float64
    data::Ptr{Cdouble}
end

# CCVDenseMatrix() = CCVDenseMatrix(0, 0, 0, 0, 0, 0, 0., Ptr{}(0))

"Use version without typ for now - only CCV_64F is supported"
function CCVDenseMatrix(rows::Int, cols::Int, typ::UInt32)
    ptr = ccall((:ccv_dense_matrix_new, libccv), Ptr{CCVDenseMatrix},
              (Cint, Cint, Cint, Ptr{Void}, UInt64),
              Cint(rows), Cint(cols), Cint(typ), C_NULL, UInt64(0))
    return unsafe_load(ptr)
end

CCVDenseMatrix(rows::Int, cols::Int) = CCVDenseMatrix(rows, cols, CCV_64F)

function Base.show(io::IO, mat::CCVDenseMatrix)
    print(io, "CCVDenseMatrix($(mat.rows),$(mat.cols))")
end

function Base.getindex(mat::CCVDenseMatrix, i::Integer)
    return unsafe_load(mat.data, i)
end

function Base.setindex!(mat::CCVDenseMatrix, i::Integer, v::Float64)
    unsafe_store!(mat.data, i, v)
end

function Base.size(mat::CCVDenseMatrix)
    return (Int(mat.rows), Int(mat.cols))
end


# function Base.read(path::AbstractString, flags::UInt16)
#     img = CCVDenseMatrix()
#     p = Array(Ptr{CCVDenseMatrix}, 1)
    
#     ccall((:ccv_read_impl, libccv), Int,
#           (Ptr{Cchar}, Ptr{Ptr{CCVDenseMatrix}}, UInt32),
#           path, p, flags)
    
# end

# int ccv_read(const void *data, ccv_dense_matrix_t **x, int type, int size)

# TODO: memory is transposed in CCV compared to Julia


function ccv_type{T}(::Type{T})
    if T == Float64
        return CCV_64F
    else
        # TODO: add other image types
        throw(ArgumentError("CCV can't handle Julia's $T type"))
    end
end

"Low-level function to create CCVDenseMatrix from Julia 1D array"
function ccv_read{T}(data::Vector{T}, rows::Int, cols::Int)
    @assert rows*cols == length(data) "rows * cols != length of data!"
    matptr = Array(Ptr{CCVDenseMatrix}, 1)    
    scanline = sizeof(T)
    typ = ccv_type(T) | CCV_IO_ANY_RAW
    code = ccall((:ccv_read_impl, libccv), Cint,
                 (Ptr{Void}, Ptr{Ptr{CCVDenseMatrix}}, Cint, Cint, Cint, Cint),
                 pointer(data), matptr, typ, rows, cols, scanline)
    if code != CCV_IO_FINAL
        throw(ErrorException("ccv_read_impl() exited with error: $code"))
    else
        return unsafe_load(matptr[1])       
    end

end

function main()
    data = [1., 2, 3, 4, 5, 6]
    mat = ccv_read(data, 3, 2)
end
