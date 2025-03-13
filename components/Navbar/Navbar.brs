sub init()
    m.navList = m.top.findNode("navList")
    setupNavItems()
end sub

sub setupNavItems()
    content = CreateObject("roSGNode", "ContentNode")
    
    navItems = [
        { iconUrl: "pkg:/images/navMenu/Home.png" }
        { iconUrl: "pkg:/images/navMenu/Film.png" }
    ]
    
    for each item in navItems
        itemContent = CreateObject("roSGNode", "NavContent")
        itemContent.iconUrl = item.iconUrl
        content.appendChild(itemContent)
    end for
    
    m.navList.content = content
end sub 