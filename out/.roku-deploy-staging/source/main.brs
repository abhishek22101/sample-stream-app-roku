<<<<<<< Updated upstream
Sub RunUserInterface()
    screen = CreateObject("roSGScreen")
    m.scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")

    m.global = screen.getGlobalNode()
    m.global.id = "GlobalNode"
    m.global.addFields({
    
    ' Add base url of local server 
    ' serverBaseUrl: "192.168.43.48:8080",
    serverBaseUrl: "https://gizmo.rakuten.tv/",
    gilroyRegularFontUri: "pkg:/fonts/Gilroy-Regular.otf",
    detailsId: "",
    })

    screen.SetMessagePort(port)
    screen.Show()
    while(true)
        msg = wait(0, port)
        print "msg = "; msg
    end while
    
    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
End Sub
=======
sub Main(args as dynamic)



  screen = CreateObject("roSGScreen")
  m.port = CreateObject("roMessagePort")
  screen.setMessagePort(m.port)

  m.global = screen.getGlobalNode()
  deeplink = {}
  if args.contentId <> invalid and args.mediaType <> invalid and (args.mediaType = "movie")
    deeplink = {
      id: args.contentId
      type: args.mediaType
    }
  end if
  m.global.addFields({ deeplinkValues: deeplink })

  scene = screen.CreateScene("MainScene")
  screen.show()

  scene.observeField("exitApp", m.port)

  while(true)
    msg = wait(0, m.port)
    msgType = type(msg)
    if msgType = "roSGScreenEvent"
      if msg.isScreenClosed() then return
    end if

    if type(msg) = "roInputEvent"
      if msg.IsInput()
        info = msg.GetInfo()
        if info.DoesExist("mediatype") and info.DoesExist("contentid")
          mediaType = info.mediatype
          contentId = info.contentid
        end if
      end if
    else if msgType = "roSGNodeEvent" then
      field = msg.getField()
      if field = "exitApp" then
        return
      end if
    end if
  end while
end sub

>>>>>>> Stashed changes
