sub init()
    m.icon = m.top.findNode("icon")
end sub

sub onItemContentChanged()
    content = m.top.itemContent
    if content <> invalid
        m.icon.uri = content.iconUrl
    end if
end sub

sub onFocusPercentChange()
    focusPercent = m.top.focusPercent
    if focusPercent > 0 AND m.top.getParent().hasFocus()
        m.icon.blendColor = "0xFFC0CBFF"
    else
        m.icon.blendColor = "0xFFFFFFFF"
    end if
end sub 