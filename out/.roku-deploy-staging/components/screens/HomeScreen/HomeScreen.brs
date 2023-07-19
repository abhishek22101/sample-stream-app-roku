Function Init()
    m.RowListScreen = m.top.findNode("RowListScreen")
    m.RowList = m.RowListScreen.findnode("List")

    m.top.observeField("visible", "onTopVisibilityChange")
End Function

Sub onTopVisibilityChange()
    if m.top.visible = false
        return
    end if
    getAPIToken()
End Sub

Sub getAPIToken()
    m.UriHandler.listener = m.top
    if m.ListAssociativeArray = invalid
        ListContent = createObject("RoSGNode","ContentNode")
        m.ListContent = ListContent.createChild("ContentNode")
        m.RowList.content = m.ListContent
        m.ListAssociativeArray = CreateObject("roAssociativeArray")
        listIds = ["populares-en-taquilla", "estrenos-para-toda-la-familia", "estrenos-imprescindibles-en-taquilla", "estrenos-espanoles", "si-te-perdiste", "especial-x-men", "nuestras-preferidas-de-la-semana"]
        for id = 0 to listIds.Count() - 1
            url = "v3/lists/"+ listIds[id] + "?classification_id=5&device_identifier=web&locale=es&market_code=es"
            finalURL = m.global.serverBaseUrl + url
            makeRequest({"Content-Type":"application/json"},finalURL,"GET",{},1)
        end for
    else
        m.RowList.setFocus(true)
    end if
End Sub

Function SetContent(response as object, title as string)
    if response.Count() <> 0
        Content = m.ListContent.createChild("ContentNode")
        Content.title = title
        for index = 0 to (response.Count() - 1)
            itemContent = Content.createChild("ContentNode")            
            if response[index].images.artwork <> invalid
                itemContent.HDPOSTERURL = response[index].images.artwork
            else
                itemContent.HDPOSTERURL = "pkg:/images/not-available.jpg"
            end if
        end for
        m.ListAssociativeArray.AddReplace(m.ListAssociativeArray.Count().ToStr(),response)
        m.RowList.content = m.ListContent
        m.RowList.setFocus(true)
    end if
End Function

Sub onAPISuccess(response as object, responseNumber as integer)
    if responseNumber = 1 
        SetContent(response.data.contents.data, response.data.name)
    else if responseNumber = 2
        
    end if
End Sub

Sub onErrorFound()
    showServerErrorDialog()
End Sub

Sub rowItemSelected()
    for each item in m.ListAssociativeArray.Items()
        if item.key = m.RowList.rowItemSelected[0].ToStr()
            ShowDetailsPage(item.value[m.RowList.rowItemSelected[1]])
        end if
    end for
End Sub

Sub ShowDetailsPage(item as object)
    m.global.detailsId = item.id
    m.Router.callFunc("NavigateTo", "DetailScreen")
end Sub

Function OnKeyEvent(key, press) as Boolean
    handled = false
    if press = false
        return false
    end if
    return handled
End Function