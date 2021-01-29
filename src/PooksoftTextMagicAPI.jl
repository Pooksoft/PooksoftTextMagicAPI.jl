module PooksoftTextMagicAPI

    # include my codes -
    include("Include.jl")

    # export types -
    export PSResult
    export PSTextMagicAPIUserObject

    # export methods -
    export load_config_file
    export send_text_message
    export build_user_model_object
    export register_file_store_watcher
    export load_csv_data_file

end # module
