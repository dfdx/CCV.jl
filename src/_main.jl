
include("core.jl")


# Base.cconvert{T}(::Ptr{CCVDenseMatrixType{T}}, mat::CCVDenseMatrix{T}) = mat

# Base.unsafe_convert{T}(::Type{Ptr{CCVDenseMatrixType{T}}}, mat::CCVDenseMatrix{T}) = mat.ptr


function scd_detect_objects{T}(mat::CCVDenseMatrix{T}, cascade::SCDClassifierCascade, count::Int,
                            params::SCDParamType)
    # cascadeout = Ref{Ptr{Void}}()    
    cascade = scd_classifier_cascade_read()
    cascadearr = pointer([cascade.ptr])
    params = SCD_DEFAULT_PARAMS
    count = 1
    mat = CCVDenseMatrix(rand(64,64))
    T = Float64
    
    # ptr = ccall((:ccv_scd_detect_objects, libccv), Ptr{CCVArrayType},
    #             (Ptr{CCVDenseMatrixType}, Ptr{Ptr{Void}}, Cint, SCDParamType),
    #             mat.ptr, cascadearr, count, params)

    ptr = ccall((:ccv_scd_detect_objects, libccv), Ptr{Void},
                (Ptr{CCVDenseMatrixType}, Ptr{Ptr{Void}}, Cint, SCDParamType),
                mat.ptr, cascadearr, count, params)

    a = unsafe_load(ptr)
    
    return CCVArray(ptr)

    # TODO: add unsafe_convert for matrix and cascade, don't pass pointers
end





function main()
    T = Float64
    data = T[1 2 3; 4 5 6]
    rows = 2
    cols = 3
    mat = CCVDenseMatrix(data)
end
