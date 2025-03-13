sub init()
    m.poster = m.top.findNode("poster")
    m.title = m.top.findNode("title")
    m.description = m.top.findNode("description")
end sub

sub onContentChanged()
    content = m.top.content
    if content <> invalid
        m.poster.uri = content.hdPosterUrl
        m.title.text = content.title
        m.description.text = content.description
    end if
end sub