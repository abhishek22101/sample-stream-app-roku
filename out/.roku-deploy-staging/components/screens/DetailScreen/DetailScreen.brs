Function Init()
    m.Title = m.top.findNode("Title")
    m.bgImage = m.top.findNode("bgImage")
    m.posterImage = m.top.findNode("posterImage")
    m.Description = m.top.findNode("Description")
    m.PlayButton = m.top.findNode("PlayButton")
    m.Loader = m.top.findNode("Loader")

    m.VideoPlayer = m.top.findNode("VideoPlayer")
    m.top.observeField("visible", "OnTopVisibilityChange")

    m.Title.font.uri = m.global.gilroyRegularFontUri
    m.Title.font.size = "50"
    m.Description.font.uri = m.global.gilroyRegularFontUri
    m.Description.font.size = "20"
End Function

Sub OnTopVisibilityChange()
    if m.top.visible = false
     return
    end if
    getMovieDetails()    
End Sub

Sub getMovieDetails()
    m.UriHandler.listener = m.top
    url = m.global.serverBaseUrl + "v3/movies/"+ m.global.detailsId + "?classification_id=5&device_identifier=web&locale=es&market_code=es"
    makeRequest({"Content-Type":"application/json"},url,"GET",{},1)

    videoUrl = m.global.serverBaseUrl + "v3/me/streamings?classification_id=5&device_identifier=web&locale=es&market_code=es"
    data = {
            "audio_language":"SPA",
            "audio_quality":"2.0",
            "content_id":m.global.detailsId,
            "content_type":"movies",
            "device_serial": "device_serial_1",
            "device_stream_video_quality":"FHD",
            "player":"web:PD-NONE",
            "subtitle_language":"MIS",
            "video_type":"trailer"
        }
    makeRequest({"Content-Type":"application/json"},videoUrl,"POST",data,2)
    FlushDetails()
End Sub

Sub playVideoFunction()
    m.VideoPlayer.visible = true
    m.VideoPlayer.control = "play"
    m.VideoPlayer.setFocus(true)
End Sub

Function StopVideo()
    m.VideoPlayer.visible = false
    m.VideoPlayer.control = "stop"
    m.PlayButton.setFocus(true)
End Function

Function FlushDetails()
    m.Loader.visible = "true"
    m.Title.text = ""
    m.Description.text = ""
    m.bgImage.uri = ""
    m.posterImage.uri = ""
End Function

Sub onAPISuccess(response as object, responseNumber as integer)
    if responseNumber = 1
        m.Title.text = response.data.title
        m.Description.text = response.data.plot
        m.bgImage.uri = response.data.images.snapshot
        m.posterImage.uri = response.data.images.artwork
        m.PlayButton.setFocus(true)
        m.Loader.visible = "false"
    else if responseNumber = 2
        contentNode = createObject("RoSGNode", "ContentNode")
        contentNode.url = response.data.stream_infos[0].url
        contentNode.title = m.Title.text
        contentNode.streamformat = "mp4"
        m.VideoPlayer.content = contentNode
    end if
End Sub

Sub onErrorFound()
    ? "Error"
End Sub

Function OnKeyEvent(key, press) as Boolean
    handled = false
    if press = false
        return false
    end if
    if key = "back" AND m.videoPlayer.visible
        StopVideo()
        handled = true
    end if
    return handled
End Function