-- globale varale
LmUtil = {}

-- gibt die laenge der tabelle zurueck
function LmUtil.tableLength(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

-- ala in_array
function LmUtil.tableHasValue (tab, val)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- abrunden
function LmUtil.round(num)
    return math.floor(num)
end

-- table key finden
function LmUtil.findTableKey(table, value)

    for k, v in pairs(table) do

        if v == value then return k end
    end

    return v
end