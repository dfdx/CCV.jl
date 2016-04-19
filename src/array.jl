
# typedef struct {
#                 int type;
#                     uint64_t sig;
#                     int refcount;
#                     int rnum;
#                     int size;
#                     int rsize;
#                     void* data;
# } ccv_array_t;


immutable CCVArrayType
    typ::Cint
    sig::UInt64
    refcount::Cint
    rnum::Cint
    size::Cint
    rsize::Cint
    data::Ptr{Void}
end


immutable CCVArray
    ptr::Ptr{CCVArrayType}
end


# TODO: finalizer
