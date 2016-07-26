local currentlyInComcat = false
local player = nil
local currentlyHasAggro = false
local listOfUnitsHasAggro = {}

-- wird gerufen wenn ein kampf status geaendert wird
function LmTank.Engine.eventCombat(_, units)

    -- spieler suchen
    if player == nil then

        -- spieler setzen
        LmTank.Engine.setPlayer(Inspect.Unit.Detail("player"))
    end

    local _combatFlag

    -- units durchgehen und nach den spieler suchen
    local foundPlayer = false
    for unit, combatFlag in pairs(units) do

        _combatFlag = combatFlag 

        -- spieler gefunden?
        if unit == player.id then

            -- in combat oder nicht?
            LmTank.Engine.setCombatState(combatFlag)

            -- nicht mehr weiter suchen
            foundPlayer = true
            break
        end

    end

    -- nur fuer den spieler den kampf signalisieren
    if (not foundPlayer and not LmTank.Engine.getCombatState()) or (not _combatFlag and not foundPlayer) then

        -- nichts tun
        return
    elseif not foundPlayer and LmTank.Engine.getCombatState() then

        -- mehr gegner kommen in den kampf.
        LmTank.Ui.pulse()

        -- aber nicht weiter machen
        return
    end

    -- soo, im kampf oder nicht?
    if LmTank.Engine.getCombatState() then

        -- kampf betreten!
        LmTank.Engine.enterCombat()
    else

        -- kampf verlassen
        LmTank.Engine.leaveCombat()
    end

end

-- event wenn sich die aggro veraendert
function LmTank.Engine.eventAggro(_, units)
    
    -- nur wenn im kampf
    if not LmTank.Engine.getCombatState() then return end

    -- units durchgehen und gucken ob jemand aggro hat
    for unit, aggro in pairs(units) do

        -- unit ist die unit die entweder nun aggro hat oder keine aggro mehr hat.
        -- player ist nicht aufgelistet, also gucken welche gruppenmitglieder aggro
        -- haben
        if aggro then

            -- unit hat nun aggro. melden!
            if not LmTank.Util.tableHasValue(listOfUnitsHasAggro, unit) then

                -- stacken wenn nicht schon vorhanden
                table.insert(listOfUnitsHasAggro, unit)
            end
        else

            -- vom stapel nehmen weil nun keine aggro mehr vorhanden ist
            table.remove(listOfUnitsHasAggro, LmTank.Util.findTableKey(listOfUnitsHasAggro, unit))
        end

    end

    -- wenn ein spieler in der liste ist dann hat jemand aggro!
    if LmTank.Util.tableLength(listOfUnitsHasAggro) > 0 then

        -- aggro verloren
        LmTank.Engine.enterAggroLostMode()
    else

        -- aggro wieder bekommen
        LmTank.Engine.leaveAggroLostMode()
    end

end

-- beginnt den aggro lost modus
function LmTank.Engine.enterAggroLostMode()

    -- farben aendern
    LmTank.Ui.setDefaultColor(LmTank.Options.colorAggroLost, true)
end

-- beendet den aggro lost modus
function LmTank.Engine.leaveAggroLostMode()

    -- farben aendern
    LmTank.Ui.setDefaultColor(nil, true)
end

-- kampf betreten?
function LmTank.Engine.enterCombat()

    -- gui anzeigen
    LmTank.Ui.show()
end

-- kampf verlassen?
function LmTank.Engine.leaveCombat()

    -- gui ausblenden
    LmTank.Ui.hide()
end

-- setter und getter funktionen fuer player und kampf status
function LmTank.Engine.getPlayer() return player end
function LmTank.Engine.setPlayer(_player) player = _player end

-- fuer combat
function LmTank.Engine.getCombatState() return currentlyInComcat end
function LmTank.Engine.setCombatState(_combat) currentlyInComcat = _combat end

-- fuer aggro
function LmTank.Engine.getAggroState() return aggro end
function LmTank.Engine.setAggroState(_aggro) aggro = _aggro end