local addon = ...

-- initialisiert das addon
local function init()

    -- nur einmal laden
    Command.Event.Detach(Event.Addon.Load.End, init, "init")

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
    print ("erfolgreich geladen (v " .. addon.toc.Version ..")")

end


-- speichert die gesetzten optionen
local function saveOptionVariables()

    -- ueberschreiben
    LmMinionGlobal = LmMinion.Options
end

-- wenn addon geladen dann init durchfuehren
Command.Event.Attach(Event.Addon.Load.End, init, "init")
Command.Event.Attach(Event.Addon.Shutdown.Begin, saveOptionVariables, "saveOptionVariables")