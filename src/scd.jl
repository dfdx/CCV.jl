
type SCDClassifierCascade
    ptr::Ptr{Void}
end


# typedef struct {
#                 int min_neighbors; /**< 0: no grouping afterwards. 1: group objects that intersects each other. > 1: group objects that intersects each other, and only passes these that have at least **min_neighbors** intersected objects. */
#                 int step_through; /**< The step size for detection. */
#                     int interval; /**< Interval images between the full size image and the half size one. e.g. 2 will generate 2 images in between full size image and half size one: image with full size, image with 5/6 size, image with 2/3 size, image with 1/2 size. */
#                     ccv_size_t size; /**< The smallest object size that will be interesting to us. */
# } ccv_scd_param_t;

immutable CCVSize
    width::Cint
    height::Cint
end

immutable SCDParamType
    min_neighbors::Cint
    step_through::Cint
    interval::Cint
    size::CCVSize
end


const SCD_DEFAULT_PARAMS = SCDParamType(5, 1, 4, CCVSize(48, 48))

const FACE_CASCADE_FILE = Pkg.dir("CCV", "deps", "ccv", "samples", "face.sqlite3")



function scd_classifier_cascade_read(path::AbstractString=FACE_CASCADE_FILE)
    ptr = ccall((:ccv_scd_classifier_cascade_read, libccv), Ptr{Void},
                (Ptr{Cchar},), path)    
    return SCDClassifierCascade(ptr)
end





# ccv_array_t* ccv_scd_detect_objects(ccv_dense_matrix_t* a, ccv_scd_classifier_cascade_t** cascades, int count, ccv_scd_param_t params)

