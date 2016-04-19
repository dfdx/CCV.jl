
include("core.jl")






function main()
    mat = CCVDenseMatrix(rand(64, 64))
    cascade = scd_classifier_cascade_read(FACE_CASCADE_FILE)
    faces = scd_detect_objects(mat, [cascade])
    a = unsafe_load(faces.ptr) # TODO: getindex for ccv_array_t
end
