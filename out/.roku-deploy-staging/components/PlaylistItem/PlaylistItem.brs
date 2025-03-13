sub init()
    m.poster = m.top.findNode("poster")
    m.title = m.top.findNode("title")
    m.focusRect = m.top.findNode("focusRect")
    m.glowEffect = m.top.findNode("glowEffect")
    m.glowAnimation = m.top.findNode("glowAnimation")
end sub

sub onItemContentChanged()
    itemContent = m.top.itemContent
    m.poster.uri = itemContent.hdPosterUrl
    m.title.text = itemContent.title
end sub

sub onFocusPercentChange()
    focusPercent = m.top.focusPercent
    
    ' Reset all visual states when focus is lost
    if focusPercent = 0
        m.poster.scale = [1, 1]
        m.focusRect.opacity = 0
        m.glowAnimation.control = "stop"
        m.glowEffect.opacity = 0
        return
    end if
    
    scale = 1 + (0.1 * focusPercent)
    m.poster.scale = [scale, scale]
    
    m.focusRect.opacity = 0.7 * focusPercent
    m.focusRect.color = "0xFFC0CBFF"
    
    if focusPercent > 0
        if not m.glowAnimation.state = "running"
            m.glowAnimation.control = "start"
        end if
    end if
end sub 