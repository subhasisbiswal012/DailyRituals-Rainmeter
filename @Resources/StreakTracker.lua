--[[
    StreakTracker.lua v5
    - Quote: one per day, sequential from verse 1 onward
    - No quote navigation
    - Fixed Add Habit via InputText
    - No shine lines
]]

local habits = {}
local MAX = 8
local todayKey = ""
local editMode = false

local quotes = {
    { t = "You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions.", s = "Bhagavad Gita 2.47" },
    { t = "The soul is neither born, nor does it die. It is unborn, eternal, and primeval.", s = "Bhagavad Gita 2.20" },
    { t = "Set your heart upon your work but never on its reward.", s = "Bhagavad Gita 2.47" },
    { t = "A person can rise through the efforts of their own mind, or degrade themselves. The mind is both friend and enemy.", s = "Bhagavad Gita 6.5" },
    { t = "There is nothing lost or wasted in this life. Even a little effort toward spiritual awareness will protect you from the greatest fear.", s = "Bhagavad Gita 2.40" },
    { t = "You are what you believe in. You become that which you believe you can become.", s = "Bhagavad Gita" },
    { t = "It is better to live your own destiny imperfectly than to live an imitation of somebody else's life with perfection.", s = "Bhagavad Gita 3.35" },
    { t = "When meditation is mastered, the mind is unwavering like the flame of a lamp in a windless place.", s = "Bhagavad Gita 6.19" },
    { t = "Death is as sure for that which is born, as birth is for that which is dead. Therefore grieve not for what is inevitable.", s = "Bhagavad Gita 2.27" },
    { t = "Through selfless service, you will always be fruitful and find the fulfillment of your desires.", s = "Bhagavad Gita 3.10" },
    { t = "Those who are motivated only by desire for the fruits of action are miserable, for they are constantly anxious about the results.", s = "Bhagavad Gita 2.49" },
    { t = "One who sees inaction in action, and action in inaction, is intelligent among men.", s = "Bhagavad Gita 4.18" },
    { t = "When a person is devoted to something with complete faith, I unify his faith in that.", s = "Bhagavad Gita 7.21" },
    { t = "Perform your obligatory duty because action is indeed better than inaction.", s = "Bhagavad Gita 3.8" },
    { t = "The wise should work without attachment, for the welfare of the society.", s = "Bhagavad Gita 3.25" },
    { t = "Whatever you do, whatever you eat, whatever you offer or give away, do that as an offering to Me.", s = "Bhagavad Gita 9.27" },
    { t = "Sever the ignorant doubt in your heart with the sword of self-knowledge. Observe your discipline. Arise.", s = "Bhagavad Gita 4.42" },
    { t = "No one who does good work will ever come to a bad end, either here or in the world to come.", s = "Bhagavad Gita 6.40" },
    { t = "The happiness which comes from long practice, at first like poison but at last like nectar, arises from serenity of mind.", s = "Bhagavad Gita 18.37" },
    { t = "Anyone steady in determination who can equally tolerate distress and happiness is certainly eligible for liberation.", s = "Bhagavad Gita 2.15" },
    { t = "Free from all thoughts of I and mine, man finds absolute peace.", s = "Bhagavad Gita 2.71" },
    { t = "The power of God is with you at all times, through the activities of mind, senses, breathing, and emotions.", s = "Bhagavad Gita 18.61" },
    { t = "He who has let go of hatred, who treats all beings with kindness, that is the man I love best.", s = "Bhagavad Gita 12.13" },
    { t = "The mind acts like an enemy for those who do not control it.", s = "Bhagavad Gita 6.6" },
    { t = "Change is the law of the universe. You can be a millionaire or a pauper in an instant.", s = "Bhagavad Gita 2.14" },
    { t = "For one who has conquered his mind, a mind is best of friends. For one who has failed, it is the greatest enemy.", s = "Bhagavad Gita 6.6" },
    { t = "A gift is pure when given from the heart to the right person at the right time, expecting nothing in return.", s = "Bhagavad Gita 17.20" },
    { t = "We shape ourselves and our world by what we believe and think and act on, for good or for ill.", s = "Bhagavad Gita" },
    { t = "One who performs duty without attachment is unaffected, as the lotus leaf is untouched by water.", s = "Bhagavad Gita 5.10" },
    { t = "Among all killers, time is the ultimate because time kills everything.", s = "Bhagavad Gita 11.32" },
}

-- Layout
local W = 340
local CX = 32
local CW = 276
local CHECK_X = 292
local ROW_H = 52

-- ============================================================
-- FILE I/O
-- ============================================================

local function habitsPath() return SKIN:MakePathAbsolute("@Resources\\habits.txt") end
local function dataPath() return SKIN:MakePathAbsolute("@Resources\\data.txt") end

local function trim(s) return s:match("^%s*(.-)%s*$") or "" end

local function loadHabits()
    habits = {}
    local f = io.open(habitsPath(), "r")
    if f then
        for line in f:lines() do
            local n = trim(line)
            if n ~= "" then table.insert(habits, n) end
        end
        f:close()
    end
    if #habits == 0 then
        habits = { "Hit the Gym", "Study 4 Hours", "Take Medicines", "Face Care Routine" }
        local f2 = io.open(habitsPath(), "w")
        if f2 then for _, h in ipairs(habits) do f2:write(h .. "\n") end f2:close() end
    end
end

local function saveHabits()
    local f = io.open(habitsPath(), "w")
    if f then for _, h in ipairs(habits) do f:write(h .. "\n") end f:close() end
end

local function readData()
    local lines = {}
    local f = io.open(dataPath(), "r")
    if f then
        for line in f:lines() do
            local l = trim(line)
            if l ~= "" then table.insert(lines, l) end
        end
        f:close()
    end
    return lines
end

local function writeData(lines)
    local f = io.open(dataPath(), "w")
    if f then for _, l in ipairs(lines) do f:write(l .. "\n") end f:close() end
end

-- ============================================================
-- HABIT STATE
-- ============================================================

local function isDone(idx)
    local key = todayKey .. "|" .. idx .. "|1"
    for _, l in ipairs(readData()) do
        if l == key then return true end
    end
    return false
end

local function setDone(idx, done)
    local prefix = todayKey .. "|" .. idx
    local data = readData()
    local out = {}
    for _, l in ipairs(data) do
        if not l:find(prefix, 1, true) then table.insert(out, l) end
    end
    if done then table.insert(out, prefix .. "|1") end
    writeData(out)
end

local function getStreak(idx)
    local data = readData()
    local streak = 0
    local t = os.time()
    local function check(ts)
        local ds = os.date("%Y-%m-%d", ts)
        for _, l in ipairs(data) do
            if l == ds .. "|" .. idx .. "|1" then return true end
        end
        return false
    end
    if check(t) then streak = 1; t = t - 86400
    else t = t - 86400 end
    for _ = 1, 365 do
        if check(t) then streak = streak + 1; t = t - 86400
        else break end
    end
    return streak
end

local function calcOverallStreak()
    local data = readData()
    local total = #habits
    if total == 0 then return 0 end
    local streak = 0
    local t = os.time()
    local function allDoneOn(ts)
        local ds = os.date("%Y-%m-%d", ts)
        for i = 1, total do
            local found = false
            for _, l in ipairs(data) do
                if l == ds .. "|" .. i .. "|1" then found = true; break end
            end
            if not found then return false end
        end
        return true
    end
    -- Same logic as individual streak:
    -- If today is all done, count today and check backward
    -- If today is NOT all done, start checking from yesterday
    if allDoneOn(t) then
        streak = 1
        t = t - 86400
    else
        t = t - 86400
    end
    for _ = 1, 365 do
        if allDoneOn(t) then
            streak = streak + 1
            t = t - 86400
        else
            break
        end
    end
    return streak
end

-- Quote of the day: sequential, based on day of year
local function getTodayQuote()
    local dayOfYear = tonumber(os.date("%j"))
    local idx = ((dayOfYear - 1) % #quotes) + 1
    return quotes[idx]
end

-- ============================================================
-- BANG HELPERS
-- ============================================================

local function opt(m, k, v) SKIN:Bang('!SetOption', m, k, tostring(v)) end
local function show(m) SKIN:Bang('!ShowMeter', m) end
local function hide(m) SKIN:Bang('!HideMeter', m) end

-- ============================================================
-- MAIN RENDER
-- ============================================================

function Render()
    local total = #habits
    local doneN = 0
    local y = 90

    for i = 1, MAX do
        local nm = "H" .. i .. "Name"
        local sk = "H" .. i .. "Streak"
        local ck = "H" .. i .. "Check"
        local dl = "H" .. i .. "Del"
        local dv = "H" .. i .. "Div"

        if i <= total then
            local done = isDone(i)
            local streak = getStreak(i)
            if done then doneN = doneN + 1 end

            opt(nm, "Text", habits[i])
            opt(nm, "X", CX)
            opt(nm, "Y", y)
            if done then
                opt(nm, "FontColor", "250,199,117,70")
            else
                opt(nm, "FontColor", "255,240,212")
            end
            show(nm)

            if streak > 0 then
                opt(sk, "Text", streak .. " day streak")
            else
                opt(sk, "Text", "Start today!")
            end
            opt(sk, "X", CX)
            opt(sk, "Y", y + 20)
            show(sk)

            opt(ck, "X", CHECK_X)
            opt(ck, "Y", y + 4)
            if done then
                opt(ck, "Shape", "Ellipse 10,10,10,10 | Fill Color 239,159,39 | Stroke Color 239,159,39 | StrokeWidth 2")
            else
                opt(ck, "Shape", "Ellipse 10,10,10,10 | Fill Color 0,0,0,0 | Stroke Color 239,159,39,60 | StrokeWidth 2")
            end

            opt(dl, "X", CHECK_X + 4)
            opt(dl, "Y", y + 2)

            if editMode then hide(ck); show(dl)
            else show(ck); hide(dl) end

            opt(dv, "X", CX)
            opt(dv, "Y", y + ROW_H - 8)
            opt(dv, "Shape", "Rectangle 0,0," .. CW .. ",1,0 | Fill Color 239,159,39,15 | StrokeWidth 0")
            if i < total then show(dv) else hide(dv) end

            y = y + ROW_H
        else
            hide(nm); hide(sk); hide(ck); hide(dl); hide(dv)
        end
    end

    -- Add button
    if editMode then
        opt("AddBtn", "X", CX)
        opt("AddBtn", "Y", y + 4)
        show("AddBtn")
        y = y + 30
    else
        hide("AddBtn")
    end

    -- Habits panel
    local panelH = y - 90 + 14
    opt("HPanel", "Shape", "Rectangle 12,76," .. (W - 24) .. "," .. panelH .. ",10 | Fill Color 255,248,238,12 | Stroke Color 239,159,39,35 | StrokeWidth 1")

    -- Overall streak panel
    local sy = 76 + panelH + 12
    local overallStreak = calcOverallStreak()
    opt("SPanel", "Shape", "Rectangle 12," .. sy .. "," .. (W - 24) .. ",44,10 | Fill Color 255,248,238,12 | Stroke Color 239,159,39,35 | StrokeWidth 1")

    opt("SLabel", "X", CX)
    opt("SLabel", "Y", sy + 14)

    if overallStreak > 0 then
        opt("SCount", "Text", "STREAK " .. overallStreak)
        opt("SCount", "FontColor", "239,159,39")
    else
        opt("SCount", "Text", "NO STREAK YET")
        opt("SCount", "FontColor", "250,199,117,60")
    end
    opt("SCount", "X", W - 32)
    opt("SCount", "Y", sy + 10)

    -- Progress panel
    local py = sy + 56
    opt("PPanel", "Shape", "Rectangle 12," .. py .. "," .. (W - 24) .. ",52,10 | Fill Color 255,248,238,12 | Stroke Color 239,159,39,35 | StrokeWidth 1")

    opt("PLabel", "X", CX)
    opt("PLabel", "Y", py + 12)
    opt("PCount", "X", W - 32)
    opt("PCount", "Y", py + 8)

    local pct = total > 0 and math.floor((doneN / total) * 100) or 0
    opt("PCount", "Text", doneN .. " / " .. total)

    local barY = py + 34
    opt("PBarBg", "X", CX)
    opt("PBarBg", "Y", barY)
    opt("PBarBg", "Shape", "Rectangle 0,0," .. CW .. ",4,2 | Fill Color 239,159,39,20 | StrokeWidth 0")
    local fillW = math.floor(CW * pct / 100)
    if fillW < 1 and doneN > 0 then fillW = 4 end
    opt("PFill", "X", CX)
    opt("PFill", "Y", barY)
    opt("PFill", "Shape", "Rectangle 0,0," .. fillW .. ",4,2 | Fill Color 239,159,39 | StrokeWidth 0")

    -- Quote panel (one per day, no navigation)
    local qy = py + 66
    local todayQ = getTodayQuote()
    opt("QPanel", "Shape", "Rectangle 12," .. qy .. "," .. (W - 24) .. ",136,10 | Fill Color 255,248,238,12 | Stroke Color 239,159,39,35 | StrokeWidth 1")

    opt("QMark", "X", 26)
    opt("QMark", "Y", qy + 8)
    opt("QText", "X", CX)
    opt("QText", "Y", qy + 32)
    opt("QText", "Text", todayQ.t)
    opt("QSrc", "X", CX)
    opt("QSrc", "Y", qy + 112)
    opt("QSrc", "Text", "-- " .. todayQ.s)

    -- Edit button
    opt("EditLabel", "Text", editMode and "Done" or "Edit")

    -- Date
    opt("DateNum", "Text", os.date("%d"))
    opt("DateDay", "Text", string.upper(os.date("%a")))

    -- BG height
    local totalH = qy + 150
    opt("BG", "Shape", "Rectangle 0,0," .. W .. "," .. totalH .. ",12 | Fill Color 26,14,5,235 | StrokeWidth 0")
    opt("BGBord", "Shape", "Rectangle 0,0," .. W .. "," .. totalH .. ",12 | Fill Color 0,0,0,1 | Stroke Color 239,159,39,35 | StrokeWidth 1")

    SKIN:Bang('!UpdateMeterGroup', 'All')
    SKIN:Bang('!Redraw')
end

-- ============================================================
-- INTERFACE
-- ============================================================

function Initialize()
    todayKey = os.date("%Y-%m-%d")
    loadHabits()
    Render()
end

function Update()
    local nd = os.date("%Y-%m-%d")
    if nd ~= todayKey then todayKey = nd; Render() end
    return 0
end

function ToggleHabit(i)
    i = tonumber(i)
    if not i or i < 1 or i > #habits or editMode then return end
    setDone(i, not isDone(i))
    Render()
end

function ToggleEdit()
    editMode = not editMode
    Render()
end

function RemoveHabit(i)
    i = tonumber(i)
    if not i or i < 1 or i > #habits then return end
    table.remove(habits, i)
    saveHabits()
    Render()
end

function AddHabitFromInput()
    if #habits >= MAX then return end
    local addY = SKIN:GetMeter('AddBtn'):GetY()
    SKIN:Bang('!SetVariable', 'InputY', tostring(addY))
    SKIN:Bang('!CommandMeasure', 'InputMeasure', 'ExecuteBatch 1')
end

function FinishAdd()
    local val = SKIN:GetVariable('NewHabitInput', '')
    if val and trim(val) ~= "" and val ~= '""' then
        table.insert(habits, trim(val))
        saveHabits()
        SKIN:Bang('!SetVariable', 'NewHabitInput', '')
    end
    Render()
end
