# === PRIVATE METHODS THAT ARE NOT EXPORTED ========================================================== #
# ==================================================================================================== #

# === PUBLIC METHODS THAT ARE EXPORTED =============================================================== #
"""
    build_user_model_object(configDictionary::Dict{String,Any})::PSResult
"""
function build_user_model_object(configDictionary::Dict{String,Any})::PSResult

    # initialize -
    # ...

    try 

        loginCredentiallDictionary = configDictionary["API"]

        # check for some keys ...
        # username -
        if (haskey(loginCredentiallDictionary,"username") == false)
            throw(ArgumentError("Configuration dictionary error: missing key username"))
        end

        # apikey -
        if (haskey(loginCredentiallDictionary,"apikey") == false)
            throw(ArgumentError("Configuration dictionary error: missing key apikey"))
        end

        # label -
        if (haskey(loginCredentiallDictionary,"label") == false)
            throw(ArgumentError("Configuration dictionary error: missing key label"))
        end

        # ok, we should have all the data to create the user object -
        userName = loginCredentiallDictionary["username"]
        apiKey = loginCredentiallDictionary["apikey"]
        label = loginCredentiallDictionary["label"]

        # build -
        user_object = PSTextMagicAPIUserObject(userName, apiKey, label)

        # return -
        return PSResult(user_object)
    catch error
        return PSResult(error)
    end
end
# ==================================================================================================== #