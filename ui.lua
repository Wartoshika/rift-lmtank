local context, frameLeft, frameTop, frameRight, frameBottom
local currentDefaultColor = nil

-- gui initialisieren
function LmTank.Ui.init(addon)

    -- gui elemente erstellen
    context = UI.CreateContext("LmTankContext")
    frameLeft = UI.CreateFrame("Mask", "LmTankLeft", context)
    frameTop = UI.CreateFrame("Mask", "LmTankTop", context)
    frameRight = UI.CreateFrame("Mask", "LmTankRight", context)
    frameBottom = UI.CreateFrame("Mask", "LmTankBottom", context)

    -- einstellungen holen
    local color = LmTank.Options.color
    local width = LmTank.Options.width
    local parent = UIParent
    local layer = LmTank.Options.layer

    -- links
    frameLeft:SetWidth(width)
    frameLeft:SetHeight(parent:GetHeight())
    frameLeft:SetBackgroundColor(color.r, color.g, color.b, color.a)
    frameLeft:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    frameLeft:SetLayer(layer)

    -- top
    frameTop:SetHeight(width)
    frameTop:SetWidth(parent:GetWidth() - width * 2)
    frameTop:SetBackgroundColor(color.r, color.g, color.b, color.a)
    frameTop:SetPoint("TOPLEFT", parent, "TOPLEFT", width, 0)
    frameTop:SetLayer(layer)

    -- right
    frameRight:SetWidth(width)
    frameRight:SetHeight(parent:GetHeight())
    frameRight:SetBackgroundColor(color.r, color.g, color.b, color.a)
    frameRight:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    frameRight:SetLayer(layer)

    -- bottom
    frameBottom:SetHeight(width)
    frameBottom:SetWidth(parent:GetWidth() - width * 2)
    frameBottom:SetBackgroundColor(color.r, color.g, color.b, color.a)
    frameBottom:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", width, 0)
    frameBottom:SetLayer(layer)

    -- erstmal verstecken
    LmTank.Ui.hide()

end

-- setzt die standard farbe
function LmTank.Ui.setDefaultColor(color, render)

    -- farbe setzen
    currentDefaultColor = color

    -- default setzen wenn color nicht gesetzt ist
    if not color then color = LmTank.Ui.setDefaultColor(LmTank.Options.color) end

    -- neu rendern?
    if render then

        -- zeit holen
        local duration = LmTank.Options.aggroColorFrequency

        -- zeichnen
        LmTank.Ui.frameSetBackgroundColor(frameLeft, currentDefaultColor, duration)
        LmTank.Ui.frameSetBackgroundColor(frameRight, currentDefaultColor, duration)
        LmTank.Ui.frameSetBackgroundColor(frameTop, currentDefaultColor, duration)
        LmTank.Ui.frameSetBackgroundColor(frameBottom, currentDefaultColor, duration)
    end
end 

-- zeigt die gui an
function LmTank.Ui.show()

    -- zeit holen
    local duration = LmTank.Options.fadeInOutTime
    
    -- alle frames anzeigen
    frameLeft:FadeIn(duration)
    frameTop:FadeIn(duration)
    frameRight:FadeIn(duration)
    frameBottom:FadeIn(duration)
end

-- versteckt die gui
function LmTank.Ui.hide()

    -- zeit holen
    local duration = LmTank.Options.fadeInOutTime
    
    -- alle frames verstecken
    frameLeft:FadeOut(duration)
    frameTop:FadeOut(duration)
    frameRight:FadeOut(duration)
    frameBottom:FadeOut(duration)

    -- default color wieder zuruecksetzen
    LmTank.Ui.setDefaultColor(nil, true)
end

-- setzt via libanimate eine hintergrundfarbe
function LmTank.Ui.frameSetBackgroundColor(frame, color, duration)

    frame:AnimateBackgroundColor(
        duration,
        "smoothstep",
        color.r,
        color.g,
        color.b,
        color.a
    )
end

-- laesst die gui pulsieren
function LmTank.Ui.pulse()

    -- animations daten holen
    local frequency = LmTank.Options.pulseFrequency
    local colorPulse = LmTank.Options.colorPulse
    
    -- forwaerts animieren
    LmTank.Ui.frameSetBackgroundColor(frameLeft, colorPulse, frequency)
    LmTank.Ui.frameSetBackgroundColor(frameRight, colorPulse, frequency)
    LmTank.Ui.frameSetBackgroundColor(frameTop, colorPulse, frequency)
    LmTank.Ui.frameSetBackgroundColor(frameBottom, colorPulse, frequency)

    -- nach ein paar augenblicken
    StartTimer(frequency, function()

        -- rueckwaerts animieren
        LmTank.Ui.frameSetBackgroundColor(frameLeft, currentDefaultColor, frequency*2)
        LmTank.Ui.frameSetBackgroundColor(frameRight, currentDefaultColor, frequency*2)
        LmTank.Ui.frameSetBackgroundColor(frameTop, currentDefaultColor, frequency*2)
        LmTank.Ui.frameSetBackgroundColor(frameBottom, currentDefaultColor, frequency*2)
        
    end)

end