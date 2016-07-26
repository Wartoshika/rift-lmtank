-- globale varale
LmUtils = {}

-- gibt die laenge der tabelle zurueck
function LmUtils.tableLength(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

-- ala in_array
function LmUtils.tableHasValue (tab, val)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- abrunden
function LmUtils.round(num)
    return math.floor(num)
end

-- table key finden
function LmUtils.findTableKey(table, value)

    for k, v in pairs(table) do

        if v == value then return k end
    end

    return v
end