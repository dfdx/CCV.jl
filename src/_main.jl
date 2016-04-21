
include("core.jl")


function main()
    mat = CCVDenseMatrix(load("img_209.jpg"))
    cascade = scd_classifier_cascade_read(FACE_CASCADE_FILE)
    faces = scd_detect_objects(mat, [cascade])
                               # SCDParamType(5, 1, 4, CCVSize(250, 250)))
    length(faces)
    
end
