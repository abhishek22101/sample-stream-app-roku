sub init()
    m.top.id = "HomePage"
    m.top.getScene().signalBeacon("AppDialogInitiate")
    m.top.getScene().signalBeacon("AppDialogComplete")
    m.rowList = m.top.findNode("rowList")
    m.navbar = m.top.findNode("navbar")
    m.navList = m.navbar.findNode("navList")
    m.backgroundPoster = m.top.findNode("backgroundPoster")
    
    ' Observe rowList focus changes for background updates
    m.rowList.observeField("rowItemSelected", "onRowItemSelected")
    m.top.observeField("visible", "onVisibilityChanged")
    
    loadShelvesData()
    
    ' Set initial focus to rowList
    m.rowList.setFocus(true)
end sub

sub loadShelvesData()
    onShelvesDataLoaded()
end sub

sub onShelvesDataLoaded()
    jsonString = ReadAsciiFile("pkg:/components/HomePage/shelves.json")
    shelvesData = ParseJson(jsonString)
    if shelvesData <> invalid and shelvesData.items <> invalid
        contentNode = CreateObject("roSGNode", "ContentNode")
        rowContent = CreateObject("roSGNode", "ContentNode")
        rowContent.title = "" 
        
        for each item in shelvesData.items
            itemContent = CreateObject("roSGNode", "ContentNode")
            itemContent.title = item.title
            itemContent.hdPosterUrl = item.posterUrl
            itemContent.description = item.description
            rowContent.appendChild(itemContent)
        end for
        
        contentNode.appendChild(rowContent)
        m.rowList.content = contentNode
    end if
end sub

sub onRowItemSelected(event as Object)
    selected = event.getData()
    row = selected[0]
    col = selected[1]
    
    selectedItem = m.rowList.content.getChild(row).getChild(col)    
    m.top.selectedContent = selectedItem
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if press
        if key = "left" and m.rowList.hasFocus()
            ' Move focus to navList when pressing left from rowList
            m.rowList.setFocus(false)
            m.navList.setFocus(true)
            return true
        else if key = "right" and m.navList.hasFocus()
            ' Move focus to rowList when pressing right from navList
            m.navList.setFocus(false)
            m.rowList.setFocus(true)
            return true
        end if
    end if
    return false
end function

sub onVisibilityChanged()
    if m.top.visible = true
        if m.rowList <> invalid
            m.rowList.visible = true
            m.rowList.setFocus(true)
        end if
    end if
end sub