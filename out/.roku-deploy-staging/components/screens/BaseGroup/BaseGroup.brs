' BaseGroup layer is designed to write commonly used functions used in all components extending BaseGroup
Function Init()
    m.UriHandler = createObject("roSGNode","UriHandler")
End Function

Function SetRouter(router as object)
    m.Router = createObject("roSGNode","ContentNode")
    m.Router = router
End Function

Function getRouter() as object
    return m.Router
End Function

Function ContentListToSimpleNode(contentList as Object) as Object
    nodeType = "ContentNode"
    result = createObject("roSGNode",nodeType)
    if result <> invalid
        for each content in contentList
            item = createObject("roSGNode", nodeType)
            item.setFields({title : content})
            result.appendChild(item)
        end for
    end if
    return result
End Function

Function makeRequest(headers as object, url as String, method as String, data as dynamic, num=0 as integer)
    context = createObject("roSGNode", "Node")
    params = {
        headers: headers,
        uri: url,
        method: method
    }
    context.addFields({
        parameters: params,
        data: data,
        response: {},
        num: num
    })
    m.UriHandler.requestnumber = num
    m.UriHandler.request = { context: context }
end Function

sub showServerErrorDialog()
      dialog = createObject("roSGNode", "Dialog")
      dialog.title = "Server Error"
      dialog.optionsDialog = true
      m.top.getScene().dialog = dialog
end sub