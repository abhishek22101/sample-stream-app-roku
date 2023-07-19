' Component used for navigation of screens 
Function Init()
    m.screenStack = []
End Function

Function OnKeyEvent(key, press) as Boolean
    result = false
    if press
        if key = "back"
            HideTop()
            result = m.screenStack.count() <> 0
        end if
    end if
    return result
End Function

Sub ShowScreen(node)
    prev = m.screenStack.peek()
    if prev <> invalid
        prev.visible = false
    end if
    node.visible = true
    node.setFocus(true)
    m.screenStack.push(node)
End Sub

Sub HideTop()
    HideScreen(invalid)
end Sub

Sub HideScreen(node as Object)
    if node = invalid OR (m.screenStack.peek() <> invalid AND m.screenStack.peek().isSameNode(node))
        last = m.screenStack.pop()
        last.visible = false
        prev = m.screenStack.peek()
        if prev <> invalid 
            prev.visible = true
            prev.setFocus(true)
        end if
    end if
End Sub

Sub NavigateTo(screenName as string)
    screen = m.top.findNode(screenName)
    SetScreenRouter(screen)
    ShowScreen(screen)
End Sub

Sub SetScreenRouter(screen as object)
    screen.callFunc("SetRouter", m.top)
End Sub