
include("core.jl")






function main()
    mat = CCVDenseMatrix(rand(64, 64))
    cascade = scd_classifier_cascade_read(FACE_CASCADE_FILE)
    faces = scd_detect_objects(mat, [cascade])
    
end
