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
# ==================================================================================================== #

# === PUBLIC METHODS THAT ARE EXPORTED =============================================================== #
function load_results_data_file(;pathToResultsFile::String)::PSResult

    # initalize -
    # ...

    try 

        # check: is file legit?
        file_check_result = _is_file_path_legit(pathToResultsFile)
        if (isa(file_check_result.value, Exception) == true)
            throw(file_check_result.value)
        end

        # ok, file is ok - load the CSV -
        df = CSV.read(pathToResultsFile,DataFrame)

        # return -
        return PSResult(df)
    catch error
        return PSResult(error)
    end

end


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

        # load the file -
        config_dictionary = TOML.parsefile(pathToConfigFile)

        # return -
        return PSResult(config_dictionary)
    catch error
        return PSResult(error)
    end
end
# ==================================================================================================== #