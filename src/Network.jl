# === PRIVATE METHODS THAT ARE NOT EXPORTED ========================================================== #
function _send_text_message(userModel::PSTextMagicAPIUserObject, phoneNumber::String,
    message::String; logger::Union{Nothing,SimpleLogger} = nothing)::PSResult

    # initialize -
    message_body_dictionary = Dict{String,Any}()
    username = userModel.userName
    apikey = userModel.apiKey

    try 

        # setup TextMagic API call -
        message_body_dictionary["text"] = message
        message_body_dictionary["phones"] = phoneNumber

        # make the call -
        raw_response = HTTP.request("POST","$(_TEXT_MAGIC_REST_ENDPOINT)/messages",
            ["Content-Type"=>"application/json","X-TM-Username"=>"$(username)",
            "X-TM-Key"=>"$(apikey)"], 
    	    JSON.json(message_body_dictionary))

        # we are going to return the response dictionary to the user -
        response_dictionary = JSON.parse(String(raw_response.body))

        # check -
        if (isnothing(logger) == false)
            with_logger(logger) do
                @info("Sent $(message) to $(phoneNumber).\n Got back: $(response_dictionary)")
            end
        end

        # return -
        return PSResult(response_dictionary)
    catch error
        return PSResult(error)
    end
end
# ==================================================================================================== #

# === PUBLIC METHODS THAT ARE EXPORTED =============================================================== #
"""
    send_text_message(userModel::PSTextMagicAPIUserObject, phoneNumberArray::Array{String,1},
        textMessageString::String; logger::Union{Nothing,SimpleLogger} = nothing)::PSResult
"""
function send_text_message(userModel::PSTextMagicAPIUserObject, phoneNumberArray::Array{String,1},
    textMessageString::String; logger::Union{Nothing,SimpleLogger} = nothing)::PSResult

    # initialize -
    flat_telephone_number_list = ""

    try 

        # we need to convert phoneNumberArray into a flat comma separated string -
        number_of_phone_numbers = length(phoneNumberArray)
        for (index,telephone_number) in enumerate(phoneNumberArray)
        
            flat_telephone_number_list*=telephone_number
            if (index<number_of_phone_numbers)
                flat_telephone_number_list*=","
            end
        end

        # make the call -
        message_send_result = _send_text_message(userModel,flat_telephone_number_list,textMessageString;
            logger=logger)
        if (isa(message_send_result.value,Exception) == true)
            throw(message_send_result.value)
        end
        return PSResult(message_send_result.value)
    catch error
        return PSResult(erorr)
    end
end

"""
    send_text_message(userModel::PSTextMagicAPIUserObject, dataTable::DataFrame, 
        messageTextCallBackFunction::Function, 
        telephoneNumberCallBackFunction::Function)::PSResult
"""
function send_text_message(userModel::PSTextMagicAPIUserObject, dataTable::DataFrame, 
    messageTextCallBackFunction::Function; logger::Union{Nothing,SimpleLogger} = nothing)::PSResult

    # initialize -
    (number_of_rows, number_of_cols) = size(dataTable)
    response_dictionary_array = Array{Dict{String, Any},1}()   # holds the reponses key'd phone number: This will miss families ...
    has_already_been_sent_set = Set{String}()   # set which hold the text of messages that have already been sent. we check to avoind duplicates

    try 

        # main loop: send messages - loop through each row in the data fram, formulate the message, grab the phone number
        # and then call the helper send message function 
        for row_index = 1:number_of_rows

            # get a row of data from the dataTable -
            data_row = dataTable[row_index, :]

            # call the message callback function to formulate the message text -
            message_callback_function_tuple = messageTextCallBackFunction(data_row)
            message_text_string = message_callback_function_tuple.message_text_string
            telephone_number_string = message_callback_function_tuple.telephone_number_string

            # check: have we sent this message already?
            if (in(message_text_string, has_already_been_sent_set) == false)
            
                # send the text - we call the helper method which does the HTTP call to TextMagic
                send_message_result = _send_text_message(userModel, telephone_number_string, message_text_string; logger=logger)
                if (isa(send_message_result.value,Exception) == true)
                    
                    if (isnothing(logger) == false)
                        with_logger(logger) do
                            @error("Message send failed: $(send_message_result.value)")
                        end
                    end
                    throw(send_message_result.value)
                end

                # store: store the response from TextMagic for logging/reporting
                individual_dictionary = send_message_result.value
                push!(response_dictionary_array, individual_dictionary)

                if (isnothing(logger) == false)
                    with_logger(logger) do
                        @info("Rcvd $(individual_dictionary)")
                    end
                end

                # store: store the message, so we don't send duplicates -
                push!(has_already_been_sent_set, message_text_string)

            else
                
                # ok: so if we get here, we tried to send a message that we already sent. 
                # log the weirdness (if we have a logger) and move on ...
                if (isnothing(logger) == false)
                    
                    # loag this weirdness ....
                    with_logger(logger) do
                        @warn("Duplicate message warning: ``message_text``=$(message_text_string)?")
                    end
                end # end if logger = nothing
            end # end in set check
        end # end for

        # return -
        return PSResult(response_dictionary_array)
    catch error
        return PSResult(error)
    end
end
# ==================================================================================================== #