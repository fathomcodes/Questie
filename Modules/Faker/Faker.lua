QuestieFaker = {}

---@type QuestieDB
local QuestieDB = QuestieLoader:ImportModule("QuestieDB")
---@type QuestiePlayer
local QuestiePlayer = QuestieLoader:ImportModule("QuestiePlayer")

local _UnitFactionGroup, _UnitLevel, _UnitRace, _UnitClass

local fakedQuestLogIds = {}
local fakedCompletedQuestIds = {}

function QuestieFaker:Reset()
    UnitFactionGroup = _UnitFactionGroup
    UnitLevel = _UnitLevel
    UnitRace = _UnitRace
    UnitClass = _UnitClass

    for questId, _ in pairs(fakedQuestLogIds) do
        QuestiePlayer.currentQuestlog[questId] = nil
    end
end

function QuestieFaker:SetFaction(targetFaction)
    if targetFaction ~= "Horde" and targetFaction ~= "Alliance" then
        print("Invalid faction to fake:", targetFaction)
        return
    end

    _UnitFactionGroup = UnitFactionGroup
    UnitFactionGroup = function(unit) return targetFaction end
end

function QuestieFaker:SetLevel(targetLevel)
    if targetLevel < 0 then
        print("Invalid level to fake:", targetLevel)
        return
    end

    _UnitLevel = UnitLevel
    UnitLevel = function(unit) return targetLevel end
end

function QuestieFaker:SetRace(targetRaceIndex, targetRaceName, targetRaceFile)
    if (not targetRaceName) then
        targetRaceName = ""
    end
    if (not targetRaceFile) then
        targetRaceFile = ""
    end

    _UnitRace = UnitRace
    UnitRace = function(unit) return targetRaceName, targetRaceFile, targetRaceIndex end
end

function QuestieFaker:SetClass(targetClassIndex, targetClassName, targetClassFile)
    if (not targetClassName) then
        targetClassName = ""
    end
    if (not targetClassFile) then
        targetClassFile = ""
    end

    _UnitClass = UnitClass
    UnitClass = function(unit) return targetClassName, targetClassFile, targetClassIndex end
end

function QuestieFaker:AddQuestToCurrentQuestlog(questId)
    fakedQuestLogIds[questId] = true

    QuestiePlayer.currentQuestlog[questId] = QuestieDB:GetQuest(questId)
end

function QuestieFaker:CompleteQuest(questId)
    fakedCompletedQuestIds[questId] = true

    Questie.db.char.complete[questId] = true
end
