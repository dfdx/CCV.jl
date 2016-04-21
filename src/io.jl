
# this doesn't work yet, but we can load images using other tools anyway

"Read image from file"
function read_image(path::AbstractString, typ::Int)
    # @assert rows*cols == length(data) "rows * cols != length of data!"
    T = Float64
    typ = CCV_IO_GRAY | CCV_IO_ANY_FILE
    matout = Ref{Ptr{CCVDenseMatrixType{T}}}()
    path = "minions.jpg"
    # scanline = sizeof(T)
    # typ = ccv_type(T) | CCV_IO_ANY_FILE
    code = ccall((:ccv_read_impl, libccv), Cint,
                 (Ptr{Cchar}, Ptr{Ptr{CCVDenseMatrixType{T}}}, Cint, Cint, Cint, Cint),
                 path, matout, typ, 0, 0, 0)
    if code != CCV_IO_FINAL
        throw(ErrorException("ccv_read_impl() exited with error: $code"))
    else
        ptr = matout[]
        return CCVDenseMatrix(ptr)
    end
end

