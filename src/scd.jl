
type SCDClassifierCascade
    ptr::Ptr{Void}
    function SCDClassifierCascade(ptr::Ptr{Void})
        cascade = new(ptr)
        finalizer(cascade, cascade -> free(cascade))
        cascade
    end
end


function free(cascade::SCDClassifierCascade)
    if cascade.ptr != C_NULL
        ccall((:ccv_scd_classifier_cascade_free, libccv), Void,
              (Ptr{Void},), cascade)
        cascade.ptr = C_NULL
    end
end



immutable SCDParamType
    min_neighbors::Cint
    step_through::Cint
    interval::Cint
    size::CCVSize
end


const SCD_DEFAULT_PARAMS = SCDParamType(5, 1, 4, CCVSize(48, 48))
const FACE_CASCADE_FILE = Pkg.dir("CCV", "deps", "ccv", "samples",
                                  "face.sqlite3")


Base.cconvert(::Type{Ptr{Void}}, cascade::SCDClassifierCascade) = cascade
Base.unsafe_convert(::Type{Ptr{Void}}, cascade::SCDClassifierCascade) =
    cascade.ptr



function scd_classifier_cascade_read(path::AbstractString=FACE_CASCADE_FILE)
    ptr = ccall((:ccv_scd_classifier_cascade_read, libccv), Ptr{Void},
                (Ptr{Cchar},), path)    
    return SCDClassifierCascade(ptr)
end


function scd_detect_objects{T}(mat::CCVDenseMatrix{T},
                               cascades::Vector{SCDClassifierCascade},
                               params::SCDParamType=SCD_DEFAULT_PARAMS)
    count = length(cascades)
    ptr = ccall((:ccv_scd_detect_objects, libccv),
                Ptr{CCVArrayType{CompType}},
                (Ptr{CCVDenseMatrixType{T}}, Ptr{Ptr{Void}},
                 Cint, SCDParamType),
                mat, cascades, count, params)
    return CCVArray{CompType}(ptr)
end


