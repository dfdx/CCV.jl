
const libccv = Pkg.dir("CCV", "deps", "ccv", "lib", "libccv.so")

include("const.jl")


# typealias CCVDenseMatrix Ptr{Void}


type CCVDenseMatrix
    dtype::Cint
    sig::UInt64
    refcount::Cint
    rows::Cint
    cols::Cint
    step::Cint
    tag::Float64
    data::Ptr{Cdouble}
end

function CCVDenseMatrix()
    return CCVDenseMatrix(0, UInt64(0), 0, 0, 0, 0, 0., C_NULL)
end


function CCVDenseMatrix(rows::Int, cols::Int, typ::Int, data::Array{Float64,2})
    rows = Cint(3)
    cols = Cint(2)
    typ = Cint(0)
    sig = UInt64(0)
    a = [1., 2, 3, 4, 5, 6]
    data = pointer(a)
    m = ccall((:ccv_dense_matrix, libccv), Ptr{CCVDenseMatrix},
              (Cint, Cint, Cint, Ptr{Void}, UInt64),
              rows, cols, typ, data, sig)
end


function Base.read(path::AbstractString, flags::UInt16)
    # img = CCVDenseMatrix()
    p = Array(Ptr{CCVDenseMatrix}, 1)
    
    ccall((:ccv_read_impl, libccv), Int,
          (Ptr{Cchar}, Ptr{Ptr{CCVDenseMatrix}}, UInt32),
          path, p, flags)
    
end


function main()
    path = expanduser("~/Pictures/batman.png")
    flags = CCV_IO_GRAY | CCV_IO_ANY_FILE
end
