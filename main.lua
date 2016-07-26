local addon = ...

-- initialisiert das addon
local function init()

    -- variablen laden
    if LmTankGlobal then

        -- variablen laden wenn definiert
        for k,v in pairs(LmTankGlobal) do

            -- einzelnd updaten
            LmTank.Options[k] = v
        end

    end

    -- gui initialisieren
    LmTank.Ui.init(addon)

    -- events registrieren
    Command.Event.Attach(Event.Unit.Detail.Combat, LmTank.Engine.eventCombat, "LmTank.Engine.eventCombat")
    Command.Event.Attach(Event.Unit.Detail.Aggro, LmTank.Engine.eventAggro, "LmTank.Engine.eventAggro")
    
    -- damit LibTimer funktioniert muss Inspect.System.Time funktionieren
    Inspect.System.Time = Inspect.Time.Server

    -- ausgabe wg. geladen
    print ("Tank Rolle erkannt, Addon erfolgreich geladen (v " .. addon.toc.Version ..")")

end

-- unregistriert alle events
local function unregister()

    -- ausgabe!
    print("Zu einer nicht Tank Rolle gewechselt, Addon wird deaktiviert.")

    -- events entfernen
    Command.Event.Detach(Event.Unit.Detail.Combat, LmTank.Engine.eventCombat, "LmTank.Engine.eventCombat")
    Command.Event.Detach(Event.Unit.Detail.Aggro, LmTank.Engine.eventAggro, "LmTank.Engine.eventAggro")

end

-- prueft die rolle ob es eine tank rolle ist und initialisiert dann das addon
local function initCheckRole()

    -- nur einmal laden
    Command.Event.Detach(Event.Addon.Load.End, initCheckRole, "initCheckRole")

    -- funktion zum pruefen ob der spieler verfuegbar ist
    local function chkPlayer(_, players)

        -- ist es der spieler?
        for player, v in pairs(players) do

            -- ist es der spieler?
            if v == "player" then

                -- bind entfernen da spieler gefunden
                Command.Event.Detach(Event.Unit.Availability.Full, chkPlayer, "initCheckRolePlayer")

                -- details holen
                local playerDetails = Inspect.Unit.Detail(player)

                -- rolle pruefen
                if playerDetails.role == "tank" then

                    -- ja! initialisieren
                    return init()
                end

                -- meldung ausgeben
                print ("Addon geladen jedoch wegen der aktuell aktiven Rolle nicht aktiviert. (v " .. addon.toc.Version ..")")
            end
        end
    end

    -- event zum pruefen binden um zu gucken ob aktuell eine tank rolle vorhanden ist
    Command.Event.Attach(Event.Unit.Availability.Full, chkPlayer, "initCheckRolePlayer")

    -- ausserdem event fuer das aendern einer rolle binden
    Command.Event.Attach(Event.Unit.Detail.Role, function()
    
        -- spieler ist verfuegbar also einfach laden
        if Inspect.Unit.Detail("player").role == "tank" then

            -- initialisieren!
            init()
        else

            -- deregistrieren
            unregister()
        end

    end, "LmTank.Event.Unit.Detail.Role")

end


-- speichert die gesetzten optionen
local function saveOptionVariables()

    -- ueberschreiben
    LmMinionGlobal = LmMinion.Options
end

-- wenn addon geladen dann init durchfuehren
Command.Event.Attach(Event.Addon.Load.End, initCheckRole, "initCheckRole")
Command.Event.Attach(Event.Addon.Shutdown.Begin, saveOptionVariables, "saveOptionVariables")