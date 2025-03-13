Sub RunUserInterface()
    screen = CreateObject("roSGScreen")
    m.scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")

    m.global = screen.getGlobalNode()
    m.global.id = "GlobalNode"
    m.global.addFields({
    
    ' Add base url of local server 

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