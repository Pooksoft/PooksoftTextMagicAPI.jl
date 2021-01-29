struct PSResult{T}
    value::T
end

struct PSTextMagicAPIUserObject

    # data -
    userName::String
    apiKey::String
    label::String

    function PSTextMagicAPIUserObject(userName::String, apiKey::String, label::String)
        this = new(userName,apiKey,label)
    end     
end