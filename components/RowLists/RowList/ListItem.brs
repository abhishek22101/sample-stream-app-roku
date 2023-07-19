Sub Init()
    m.Image = m.top.findNode("Image")
End Sub

' Changed the item content on focus move
Sub itemContentChanged()
    m.Image.uri = m.top.itemContent.HDPOSTERURL
End Sub