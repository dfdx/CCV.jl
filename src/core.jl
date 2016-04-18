
const libccv = Pkg.dir("CCV", "deps", "ccv", "lib", "libccv.so")

include("const.jl")
include("utils.jl")


# low-level C version, use CCVDenseMatrix instead
@runonce immutable CCVDenseMatrixStruct{T}
    dtype::Cint
    sig::UInt64
    refcount::Cint
    rows::Cint
    cols::Cint
    step::Cint
    tag::Float64 # can actually be anything, but mapping to C requires this files to be 64 bits
    data::Ptr{T}
end


# CCVDenseMatrixStruct{T}(::Type{T}) =
#     CCVDenseMatrixStruct(Cint(0), UInt64(0), Cint(0), Cint(0), Cint(0), Cint(0), 0., Ptr{T}(0))


@runonce type CCVDenseMatrix{T} <: AbstractArray{T,2}
    ptr::Ptr{CCVDenseMatrixStruct{T}}    
end

function CCVDenseMatrix(ptr::Ptr{CCVDenseMatrixStruct})
    mat = new(ptr)
    finalizer(mat, mat -> free(mat))
    mat
end




"Use version without typ for now - only CCV_64F is supported"
function CCVDenseMatrix(rows::Int, cols::Int, typ::UInt32)
    T = julia_type(typ)
    ptr = ccall((:ccv_dense_matrix_new, libccv), Ptr{CCVDenseMatrixStruct{T}},
              (Cint, Cint, Cint, Ptr{Void}, UInt64),
              Cint(rows), Cint(cols), Cint(typ), C_NULL, UInt64(0))
    return CCVDenseMatrix(ptr)
end


function free(mat::CCVDenseMatrix)
    if mat.ptr != C_NULL
        ccall((:ccv_matrix_free, libccv), Void, (Ptr{CCVDenseMatrixStruct},), mat.ptr)
        mat.ptr = C_NULL
    end
end


# function finalizer(mat::CCVDenseMatrix, mat -> free(mat))
    
# end

CCVDenseMatrix(rows::Int, cols::Int) = CCVDenseMatrix(rows, cols, CCV_64F)

function Base.show(io::IO, mat::CCVDenseMatrix)
    struct = unsafe_load(mat.ptr)
    print(io, "CCVDenseMatrix($(struct.rows),$(struct.cols))")
end

# for REPL
Base.writemime(io::IO, ::MIME"text/plain", mat::CCVDenseMatrix) = show(io, mat)

Base.linearindexing(::Type{CCVDenseMatrix}) = Base.LinearFast()


function Base.getindex(mat::CCVDenseMatrix, i::Integer)
    struct = unsafe_load(mat.ptr)
    offset = i
    if i < 1 || i > struct.rows * struct.cols
        throw(BoundsError("Index $(i) is outside of " *
                          "matrix length $(struct.rows * struct.cols)"))
    end
    return unsafe_load(struct.data, offset)
end

function Base.getindex(mat::CCVDenseMatrix, i::Integer, j::Integer)
    struct = unsafe_load(mat.ptr)
    offset = struct.cols * (i-1) + j
    if i < 1 || i > struct.rows || j < 1 || j > struct.cols
        throw(BoundsError("Index $((i, j)) is outside of " *
                          "matrix size $((struct.rows, struct.cols))"))
    end
    return unsafe_load(struct.data, offset)
end


function Base.setindex!{T}(mat::CCVDenseMatrix{T}, v::T, i::Integer, j::Integer)
    struct = unsafe_load(mat.ptr)
    offset = struct.cols * (i-1) + j
    if i < 1 || i > struct.rows || j < 1 || j > struct.cols
        throw(BoundsError("Index $((i, j)) is outside of " *
                          "matrix size $((struct.rows, struct.cols))"))
    end
    return unsafe_store!(struct.data, v, offset)
end

function Base.setindex!{T}(mat::CCVDenseMatrix{T}, v::T, i::Integer)
    struct = unsafe_load(mat.ptr)
    offset = i
    if i < 1 || i > struct.rows * struct.cols
        throw(BoundsError("Index $((i, j)) is outside of " *
                          "matrix size $((struct.rows, struct.cols))"))
    end
    return unsafe_store!(struct.data, v, offset)
end


function Base.size(mat::CCVDenseMatrix)
    struct = unsafe_load(mat.ptr)
    return (Int(struct.rows), Int(struct.cols))
end

function matrix_free(mat::CCVDenseMatrix)
    ccall((:ccv_matrix_free, libccv), Void, (Ptr{CCVDenseMatrix},), pointer(CCVDenseMatrix[mat]))
end


const CCV2JULIA_TYPE =
    Dict(CCV_8U => UInt8,
         CCV_32S => Int32,
         CCV_32F => Float32,
         CCV_64S => Int64,
         CCV_64F => Float64)

const JULIA2CCV_TYPE = Dict(zip(values(CCV2JULIA_TYPE), keys(CCV2JULIA_TYPE)))


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


"Low-level function to create CCVDenseMatrix from Julia 1D array"
function ccv_read{T}(data::Vector{T}, rows::Int, cols::Int)
    @assert rows*cols == length(data) "rows * cols != length of data!"
    matout = Ref{Ptr{CCVDenseMatrixStruct{T}}}()
    scanline = sizeof(T)
    typ = ccv_type(T) | CCV_IO_ANY_RAW
    code = ccall((:ccv_read_impl, libccv), Cint,
                 (Ptr{Void}, Ptr{Ptr{CCVDenseMatrixStruct{T}}}, Cint, Cint, Cint, Cint),
                 data, matout, typ, rows, cols, scanline)
    if code != CCV_IO_FINAL
        throw(ErrorException("ccv_read_impl() exited with error: $code"))
    else
        ptr = matout[]
        return CCVDenseMatrix(ptr)
    end
end


function Base.convert{T}(::Type{CCVDenseMatrix}, arr::Array{T,2})
    tarr = arr'  # convert underlying memory from column-major to row-major layout
    rows, cols = size(arr)
    return ccv_read(reshape(tarr, rows*cols), rows, cols)
end


function main()
    T = Float64
    data = T[1 2 3; 4 5 6]
    rows = 2
    cols = 3
    mat = CCVDenseMatrix(data)
end
