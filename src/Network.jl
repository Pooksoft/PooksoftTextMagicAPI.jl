# === PRIVATE METHODS THAT ARE NOT EXPORTED ========================================================== #
function _send_text_message(userModel::PSTextMagicAPIUserObject, phoneNumber::String,
    message::String)::PSResult

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

        # return -
        return PSResult(response_dictionary)
    catch error
        return PSResult(error)
    end
end
# ==================================================================================================== #

# === PUBLIC METHODS THAT ARE EXPORTED =============================================================== #
"""
    send_text_message(userModel::PSTextMagicAPIUserObject, dataTable::DataFrame, 
        messageTextCallBackFunction::Function, 
        telephoneNumberCallBackFunction::Function)::PSResult
"""
function send_text_message(userModel::PSTextMagicAPIUserObject, dataTable::DataFrame, 
    messageTextCallBackFunction::Function, 
    telephoneNumberCallBackFunction::Function)::PSResult

    # initialize -
    (number_of_rows, number_of_cols) = size(dataTable)
    response_dictionary = Dict{String, Any}()

    try 

        # main loop: send messages -
        for row_index = 1:number_of_rows

            # get a row of data from the dataTable -
            data_row = dataTable[row_index, :]

            # call the message callback function to formulate the message text -
            message_text_string = messageTextCallBackFunction(data_row)

            # call the telephone call function -
            telephone_number_string = telephoneNumberCallBackFunction(data_row)

            # send the text - we call the helper method
            send_message_result = _send_text_message(userModel, telephone_number_string, message_text_string)
            if (isa(send_message_result.value,Exception) == true)
                throw(send_message_result.value)
            end
            individual_dictionary = send_message_result.value
            response_dictionary[telephone_number_string] = individual_dictionary
        end

        # return -
        return PSResult(response_dictionary)
    catch error
        return PSResult(error)
    end
end
# ==================================================================================================== #