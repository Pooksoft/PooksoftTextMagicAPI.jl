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
    export load_csv_data_file

    # filestore watcher methods -
    export register_file_store_watcher
    export unregister_file_store_watcher

end # module
