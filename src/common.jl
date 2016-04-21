
immutable RectType
    x::Cint
    y::Cint
    width::Cint
    height::Cint
end


immutable ClassificationType
    id::Cint
    confidence::Cfloat
end

immutable CompType
    rect::RectType
    neighbors::Cint
    classification::ClassificationType
end



immutable CCVSize
    width::Cint
    height::Cint
end
