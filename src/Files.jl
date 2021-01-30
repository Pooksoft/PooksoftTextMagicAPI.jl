# === PRIVATE METHODS THAT ARE NOT EXPORTED ========================================================== #
function _is_file_path_legit(pathToFile::String)::PSResult

    if (isfile(pathToFile) == false)

        # error message -
        error_message = "Ooops! $(pathToFile) does not exist."
        error_object = ArgumentError(error_message)

        # return -
        return PSResult{ArgumentError}(error_object)
    end

    # default: return nothing -
    return PSResult(nothing)
end

function _is_dir_path_legit(pathToDirectory::String)::PSResult

    # check -
    if (isdir(pathToDirectory) == false)
        
         # error message -
         error_message = "Ooops! $(pathToDirectory) does not exist."
         error_object = ArgumentError(error_message)
 
         # return -
         return PSResult{ArgumentError}(error_object)
    end

    # default: return nothing -
    return PSResult(nothing)
end

function _is_csv_file(pathToFile::String)::PSResult

    # get the basename -
    file_name_w_extension = basename(pathToFile)
    if (occursin(".csv",file_name_w_extension) == false)
        
        # error message -
        error_message = "Ooops! $(pathToFile) is not a comma seperated value file."
        error_object = ArgumentError(error_message)

        # return -
        return PSResult{ArgumentError}(error_object)
    end

    # default: return nothing -
    return PSResult(nothing)
end

# ==================================================================================================== #

# === PUBLIC METHODS THAT ARE EXPORTED =============================================================== #
"""
    load_csv_data_file(;pathToDataFile::String)::PSResult
"""
function load_csv_data_file(;pathToDataFile::String)::PSResult

    # initalize -
    # ...

    try 

        # check: is file legit?
        file_check_result = _is_file_path_legit(pathToDataFile)
        if (isa(file_check_result.value, Exception) == true)
            throw(file_check_result.value)
        end

        # check: is this a CSV file?
        csv_file_check_result = _is_csv_file(pathToDataFile)
        if (isa(csv_file_check_result.value, Exception) == true)
            throw(csv_file_check_result.value)
        end

        # ok, file is ok - load the CSV -
        df = CSV.read(pathToDataFile,DataFrame)

        # return -
        return PSResult(df)
    catch error
        return PSResult(error)
    end

end


function unregister_file_store_watcher(; pathToInputDirectory::String)::PSResult

    # initialize -
    # ...

    try

        # check: is this a legit directory?
        directory_check_result = _is_dir_path_legit(pathToInputDirectory)
        if (isa(directory_check_result.value, Exception) == true)
            throw(directory_check_result.value)
        end

        # ok: so we have a legit directory, let's watch for file updates.
        unwatch_event_pair = FileWatching.watch_folder(pathToInputDirectory)

        # return -
        return PSResult(unwatch_event_pair)
    catch error
        return PSResult(error)
    end
end


"""
    register_file_store_watcher(; pathToInputDirectory::String)::PSResult
"""
function register_file_store_watcher(; pathToInputDirectory::String)::PSResult

    # initialize -
    # ...

    try

        # check: is this a legit directory?
        directory_check_result = _is_dir_path_legit(pathToInputDirectory)
        if (isa(directory_check_result.value, Exception) == true)
            throw(directory_check_result.value)
        end

        # ok: so we have a legit directory, let's watch for file updates.
        watch_event_pair = FileWatching.watch_folder(pathToInputDirectory)

        # ok, so if we get here - then we need to unregister ...
        FileWatching.unwatch_folder(pathToInputDirectory)

        # return -
        return PSResult(watch_event_pair)
    catch error
        return PSResult(error)
    end
end

function load_config_file(;pathToConfigFile::String = joinpath(_PATH_TO_CONFIG,"Config.toml"))::PSResult

    # initialize -
    # ...
    
    try 

        # check: is file legit?
        file_check_result = _is_file_path_legit(pathToConfigFile)
        if (isa(file_check_result.value, Exception) == true)
            throw(file_check_result.value)
        end

        # TODO: check is this a TOML file?

        # load the file -
        config_dictionary = TOML.parsefile(pathToConfigFile)

        # return -
        return PSResult(config_dictionary)
    catch error
        return PSResult(error)
    end
end
# ==================================================================================================== #