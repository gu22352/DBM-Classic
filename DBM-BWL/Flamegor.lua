local mod	= DBM:NewMod("Flamegor", "DBM-BWL", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("@file-date-integer@")
mod:SetCreatureID(11981)
mod:SetEncounterID(615)
mod:SetModelID(6377)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 23339 22539",
	"SPELL_CAST_SUCCESS 23342"
)

--(ability.id = 23339 or ability.id = 22539) and type = "begincast"
local warnWingBuffet		= mod:NewCastAnnounce(23339, 2)
local warnShadowFlame		= mod:NewCastAnnounce(22539, 2)
local warnFrenzy			= mod:NewSpellAnnounce(23342, 3, nil, "Tank", 2)

local timerWingBuffet		= mod:NewCDTimer(31, 23339, nil, nil, nil, 2)
local timerShadowFlameCD	= mod:NewCDTimer(14, 22539, nil, false)--14-21
local timerFrenzyNext 		= mod:NewNextTimer(10, 23342, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)

function mod:OnCombatStart(delay)
	timerShadowFlameCD:Start(18-delay)
	timerWingBuffet:Start(30-delay)
end

do
	local WingBuffet, ShadowFlame = DBM:GetSpellInfo(23339), DBM:GetSpellInfo(22539)
	function mod:SPELL_CAST_START(args)--did not see ebon use any of these abilities
		--if args.spellId == 23339 then
		if args.spellName == WingBuffet then
			warnWingBuffet:Show()
			timerWingBuffet:Start()
			DBM:AddMsg("if you see this message, @deadlybossmods on twitter")
		--elseif args.spellId == 22539 then
		elseif args.spellName == ShadowFlame then
			warnShadowFlame:Show()
			timerShadowFlameCD:Start()
		end
	end
end

do
	local Frenzy = DBM:GetSpellInfo(23342)
	function mod:SPELL_CAST_SUCCESS(args)
		--if args.spellId == 23342 then
		if args.spellName == Frenzy and args:IsSrcTypeHostile() then
			warnFrenzy:Show()
			timerFrenzyNext:Start()
		end
	end
end
