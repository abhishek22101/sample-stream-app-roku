sub init()
    ' ... existing code ...
    m.homePage = m.top.findNode("homePage")
    m.movieDetailsPage = m.top.findNode("movieDetailsPage")
    
    ' Observe movie selection
    m.homePage.observeField("selectedContent", "onMovieSelected")
    
    ' Set initial focus
    m.homePage.setFocus(true)
    ' ... existing code ...
end sub


sub onMovieSelected()
    if m.homePage.selectedContent <> invalid
        ' Show movie details page
        m.movieDetailsPage.content = m.homePage.selectedContent
        m.movieDetailsPage.visible = true
        m.homePage.visible = false
        m.movieDetailsPage.setFocus(true)
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if press and key = "back"
        if m.movieDetailsPage.visible
            ' Return to home page
            m.movieDetailsPage.visible = false
            m.homePage.visible = true
            m.homePage.setFocus(true)
            
            return true
        end if
    end if
    return false
end function
