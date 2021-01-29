# === PRIVATE METHODS THAT ARE NOT EXPORTED ========================================================== #
# ==================================================================================================== #

# === PUBLIC METHODS THAT ARE EXPORTED =============================================================== #
function send_text_message(userModel::PSTextMagicAPIUserObject, dataFrame::DataFrame)::PSResult

    # initialize -
    (number_of_rows, number_of_cols) = size(dataFrame)
    response_dictionary = Dict{String, Any}()

    # message template -
    #Hi <first_name>. Your COVID19 test taken on <test_date> is <result>. 
    #Your report will be emailed to you. Thank you for testing with Aspirar Medical Lab.


    try 

        # main loop: send messages -
        for message_index = 1:number_of_rows
            
            # grab the keys -
            firstName = dataFrame[message_index, :first_name]
            dateOfTest = dataFrame[message_index, :test_date]
            testResult = dataFrame[message_index, :result]
            telNumber = dataFrame[message_index, :phone_number]

            # telNumber is imported as Int64 - we need it as a string -
            telephone_number = string(telNumber)
            
            # results should be uppercase -
            result_string_uppercase = uppercase(testResult)

            # formulate the text message text -
            message_text = "Hi $(firstName). Your COVID19 test take on $(dateOfTest) was: $(result_string_uppercase). Your report will be emailed to you. Thank you for testing with Aspirar Medical Lab."
            
            # send the text -
            send_message_result = send_text_message(userModel, telephone_number, message_text)
            if (isa(send_message_result.value,Exception) == true)
                throw(send_message_result.value)
            end
            individual_dictionary = send_message_result.value
            response_dictionary[telephone_number] = individual_dictionary
            @show message_text
        end

        # return -
        return PSResult(response_dictionary)
    catch error
        return PSResult(error)
    end
end


function send_text_message(userModel::PSTextMagicAPIUserObject, phoneNumber::String,
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