' inits UriHandler
sub init()
    m.port = createObject("roMessagePort")
    m.top.observeField("request", m.port)
    m.top.functionName = "startObserving"
    m.top.control = "RUN"
end sub

' Start the request peocessing
Function startObserving()
    m.RequestArray = {}
    while true
        msg = wait(0, m.port)
        messageTypeValue = type(msg)
        if messageTypeValue = "roSGNodeEvent"
            if msg.getField() = "request"
                if addRequest(msg.getData()) <> true then print "Invalid request"
            end if
        else if messageTypeValue = "roUrlEvent"
            processResponse(msg)
        end if
    end while
End Function

' Retrive the API request details and prepare the request to generate response
Function addRequest(request as Object) as Boolean
    if type(request) = "roAssociativeArray"
        context = request.context
        if type(context) = "roSGNode"
            parameters = context.parameters
            if type(parameters) = "roAssociativeArray"
                headers = parameters.headers
                method = parameters.method
                uri = parameters.uri
                if type(uri) = "roString"
                    urlXfer = createObject("roUrlTransfer")
                    urlXfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
                    urlXfer.AddHeader("X-Roku-Reserved-Dev-Id", "")
                    urlXfer.InitClientCertificates()
                    urlXfer.setUrl(uri)
                    urlXfer.setPort(m.port)
                    for each header in headers
                        urlXfer.AddHeader(header, headers.lookup(header))
                    end for
                    idKey = stri(urlXfer.getIdentity()).trim()                
                    if method = "POST"
                        urlXfer.setRequest(method)
                        data = context.data
                        if type(data) = "roAssociativeArray"
                            data = FormatJson(data)
                            ok = urlXfer.AsyncPostFromString(data)
                        else
                            ok = urlXfer.AsyncPostFromString(data)
                        end if
                    else
                        ok = urlXfer.AsyncGetToString()
                    end if
                    if ok then
                        m.RequestArray[idKey] = {
                        context: request,
                        xfer: urlXfer
                      }
                    else
                      return false
                    end if
                end if
            else
                return false
            end if
        else
            return false
        end if
    else
        return false
    end if
    return true
End Function

' Get the prepare request and proceed to get the response
Function processResponse(msg as Object)
    idKey = stri(msg.GetSourceIdentity()).trim()
    job = m.RequestArray[idKey]
    if job <> invalid
        context = job.context
        parameters = context.context.parameters
        uri = parameters.uri
        jobnum = job.context.context.num
        method = parameters.method
        result = {
            code : msg.GetResponseCode(),
            headers : msg.GetResponseHeaders(),
            content : msg.GetString(),
            num : jobnum
        }
        m.RequestArray.delete(idKey)
        if msg.GetResponseCode() = 200
            parseResponse(msg, result.num)
        else
            m.top.listener.callFunc("onErrorFound")
        end if
    else
        m.top.listener.callFunc("onErrorFound")
    end if
End Function

Function parseResponse(msg as Object, num as integer)
    JSONstring = msg.GetString()
    JSON = ParseJSON(JSONstring)
    if JSON <> invalid
        m.top.listener.callFunc("onAPISuccess", JSON, num)
    else
        m.top.errorFound = true
    end if
End Function