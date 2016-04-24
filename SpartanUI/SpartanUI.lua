-----------------------------------------------------------------------------------------------
--| Purpose: SpartanUI logic																|--
--| Authors: Ansu (a.k.a. Atriace), Beladona												|--
--| Website: www.SpartanUI.com																|--
-----------------------------------------------------------------------------------------------
function Sui_OnLoad()
	SlashCmdList["SUI"] = Sui_SlashCommand
	SLASH_SUI1 = "/sui"
	SLASH_SUI2 = "/spartanui"
	SUI_currentVersion = 2.14
	SUI_devmode = false
	Sui_RegisterEvents()
end

function Sui_InitializeVariables(protectVars)
	godmode=0
	-- Saved vars that need to be saved.
	local i, curVar, varKind = 1
	local protectedVars = {
		[1] = { "buffToggle" },
		[2] = { "partyToggle" },
		[3] = { "chatter" },
		[4] = { "scale" },
		[5] = { "popUps" },
		[6] = { "raidIcons" },
		[7] = { "PartyInRaid" },
		[8] = { "autoresToggle" },
	}
	if protectVars then
		while protectedVars[i] and protectedVars[i][1] do
			curVar = protectedVars[i][1]
			varKind = type(suiData[curVar])
			-- DEFAULT_CHAT_FRAME:AddMessage(curVar.." = "..(tostring(suiData[curVar])).." ("..varKind..")", 0.5, 0.5, 0.5)
			if suiData and suiData[curVar] then
				varKind = type(suiData[curVar])
				protectedVars[i][2] = suiData[curVar]
			else
				protectedVars[i][2] = nil
			end
			i = i + 1
		end
	end
	suiData = {
		dbVersion = SUI_currentVersion,
		isSpinning = 0,
		FrameAdvance = 0,
		UpdateInterval = 1,
		GeneralInterval = 0,
		AnimationInterval = 0,
		FastInterval = 0,
		FrequentInterval = 0,
		delayedCalls = {},
		sessionMarker = GetTime(),
		sessionXP = UnitXP("player"),
		scale = .87,
		popUps = "on",
		buffToggle = "on",
		partyToggle = "on",
		autoresToggle = "on",
		PartyInRaid = "off",
		layout = "Standard",
		raidIcons = "Default",
		unit = {
			[1] = {
				["frame"] = "SUI_Self",
				["unit"] = "player",
				["direction"] = "left",
				["runDirection"] = "left",
				["castbar_width"] = 146,
				["castbar_height"] = 16,
				["healthbar_width"] = 148,
				["healthbar_height"] = 16,
				["powerbar_width"] = 155,
				["powerbar_height"] = 15,
				["buffSize"] = 20,
				["buffPadding"] = 4,
				["buffLimit"] = 12,
				["debuffLimit"] = 12,
				["weaponLimit"] = 2,
			},
			[2] = {
				["frame"] = "SUI_Target",
				["unit"] = "target",
				["direction"] = "right",
				["runDirection"] = "right",
				["castbar_width"] = 146,
				["castbar_height"] = 16,
				["healthbar_width"] = 148,
				["healthbar_height"] = 16,
				["powerbar_width"] = 155,
				["powerbar_height"] = 15,
				["buffSize"] = 20,
				["buffPadding"] = 4,
				["buffLimit"] = 12,
				["debuffLimit"] = 12,
			},
			[3] = {
				["frame"] = "SUI_Party1",
				["unit"] = "party1",
				["direction"] = "left",
				["runDirection"] = "right",
				["castbar_width"] = 120,
				["castbar_height"] = 15,
				["healthbar_width"] = 120,
				["healthbar_height"] = 15,
				["powerbar_width"] = 136,
				["powerbar_height"] = 14,
				["buffSize"] = 14,
				["buffPadding"] = 2,
				["buffLimit"] = 3,
				["debuffLimit"] = 3,
			},
			[4] = {
				["frame"] = "SUI_Party2",
				["unit"] = "party2",
				["direction"] = "left",
				["runDirection"] = "right",
				["castbar_width"] = 120,
				["castbar_height"] = 15,
				["healthbar_width"] = 120,
				["healthbar_height"] = 15,
				["powerbar_width"] = 136,
				["powerbar_height"] = 14,
				["buffSize"] = 14,
				["buffPadding"] = 2,
				["buffLimit"] = 3,
				["debuffLimit"] = 3,
			},
			[5] = {
				["frame"] = "SUI_Party3",
				["unit"] = "party3",
				["direction"] = "left",
				["runDirection"] = "right",
				["castbar_width"] = 120,
				["castbar_height"] = 15,
				["healthbar_width"] = 120,
				["healthbar_height"] = 15,
				["powerbar_width"] = 136,
				["powerbar_height"] = 14,
				["buffSize"] = 14,
				["buffPadding"] = 2,
				["buffLimit"] = 3,
				["debuffLimit"] = 3,
			},
			[6] = {
				["frame"] = "SUI_Party4",
				["unit"] = "party4",
				["direction"] = "left",
				["runDirection"] = "right",
				["castbar_width"] = 120,
				["castbar_height"] = 15,
				["healthbar_width"] = 120,
				["healthbar_height"] = 15,
				["powerbar_width"] = 136,
				["powerbar_height"] = 14,
				["buffSize"] = 14,
				["buffPadding"] = 2,
				["buffLimit"] = 3,
				["debuffLimit"] = 3,
			},
			[7] = {
				["frame"] = "SUI_TOT",
				["unit"] = "targettarget",
				["direction"] = "right",
				["runDirection"] = "left",
				["castbar_width"] = 120,
				["castbar_height"] = 15,
				["healthbar_width"] = 120,
				["healthbar_height"] = 15,
				["powerbar_width"] = 136,
				["powerbar_height"] = 14,
				["buffSize"] = 14,
				["buffPadding"] = 2,
				["buffLimit"] = 3,
				["debuffLimit"] = 3,
			},
			[8] = {
				["frame"] = "SUI_TOTT",
				["unit"] = "targettargettarget",
				["direction"] = "right",
				["runDirection"] = "left",
				["castbar_width"] = 120,
				["castbar_height"] = 15,
				["healthbar_width"] = 120,
				["healthbar_height"] = 15,
				["powerbar_width"] = 136,
				["powerbar_height"] = 14,
				["buffSize"] = 14,
				["buffPadding"] = 2,
				["buffLimit"] = 0,
				["debuffLimit"] = 0,
			},
			[9] = {
				["frame"] = "SUI_Focus",
				["unit"] = "focus",
				["direction"] = "right",
				["runDirection"] = "left",
				["castbar_width"] = 130,
				["castbar_height"] = 12,
				["healthbar_width"] = 130,
				["healthbar_height"] = 13,
				["powerbar_width"] = 130,
				["powerbar_height"] = 13,
				["buffSize"] = 14,
				["buffPadding"] = 2,
				["buffLimit"] = 3,
				["debuffLimit"] = 3,
			},
			[10] = {
				["frame"] = "SUI_Pet",
				["unit"] = "pet",
				["direction"] = "left",
				["runDirection"] = "right",
				["castbar_width"] = 100,
				["castbar_height"] = 10,
				["healthbar_width"] = 130,
				["healthbar_height"] = 13,
				["powerbar_width"] = 130,
				["powerbar_height"] = 13,
				["buffSize"] = 14,
				["buffPadding"] = 2,
				["buffLimit"] = 3,
				["debuffLimit"] = 3,
			},
			[11] = {
				["frame"] = "SUI_PartyPet1",
				["unit"] = "partypet1",
				["direction"] = "left",
				["healthbar_width"] = 130,
				["healthbar_height"] = 13,
				["buffLimit"] = 0,
				["debuffLimit"] = 0,
			},
			[12] = {
				["frame"] = "SUI_PartyPet2",
				["unit"] = "partypet1",
				["direction"] = "left",
				["healthbar_width"] = 130,
				["healthbar_height"] = 13,
				["buffLimit"] = 0,
				["debuffLimit"] = 0,
			},
			[13] = {
				["frame"] = "SUI_PartyPet3",
				["unit"] = "partypet1",
				["direction"] = "left",
				["healthbar_width"] = 130,
				["healthbar_height"] = 13,
				["buffLimit"] = 0,
				["debuffLimit"] = 0,
			},
			[14] = {
				["frame"] = "SUI_PartyPet4",
				["unit"] = "partypet1",
				["direction"] = "left",
				["healthbar_width"] = 130,
				["healthbar_height"] = 13,
				["buffLimit"] = 0,
				["debuffLimit"] = 0,
			},
		},
	}
	if protectVars then
		i = 1
		while protectedVars[i] and protectedVars[i][1] do
			curVar = protectedVars[i][1]
			-- DEFAULT_CHAT_FRAME:AddMessage(curVar.." = "..(tostring(protectedVars[i][2])), 0.5, 0.5, 1)
			suiData[curVar] = protectedVars[i][2]
			i = i + 1
		end
	end
end
-----------------------------------------------------------------------------------------------
--|	Purpose:	Registers for events.														|--
-----------------------------------------------------------------------------------------------
function Sui_RegisterEvents()
	local events = {
		"ADDON_LOADED",
		"PLAYER_ENTERING_WORLD",
		"CHAT_MSG_ADDON",
		"CHAT_MSG_COMBAT_FACTION_CHANGE",
		"CHAT_MSG_COMBAT_XP_GAIN",
		"CHAT_MSG_SYSTEM",
		"COMBAT_LOG_EVENT",
		"PARTY_LEADER_CHANGED",
		"PARTY_LOOT_METHOD_CHANGED",
		"PARTY_MEMBERS_CHANGED",
		"PLAYER_DEAD",
		"PLAYER_ALIVE",
		"PLAYER_ENTER_COMBAT",
		"PLAYER_AURAS_CHANGED",
		"PLAYER_COMBO_POINTS",
		"PLAYER_FLAGS_CHANGED",
		"PLAYER_FOCUS_CHANGED",
		"PLAYER_LEAVE_COMBAT",
		"PLAYER_LEAVING_WORLD",
		"PLAYER_REGEN_DISABLED",
		"PLAYER_REGEN_ENABLED",
		"PLAYER_TARGET_CHANGED",
		"PLAYER_UPDATE_RESTING",
		"PLAYER_XP_UPDATE",
		"QUEST_LOG_UPDATE",
		"RAID_ROSTER_UPDATE",
		"RAID_TARGET_UPDATE",
		"READY_CHECK",
		"READY_CHECK_CONFIRM",
		"READY_CHECK_FINISHED",
		"TIME_PLAYED_MSG",
		"INSPECT_TALENT_READY",
		"UNIT_AURA","UNIT_COMBAT",
		"UNIT_ENERGY","UNIT_FACTION",
		"UNIT_FOCUS",
		"UNIT_HAPPINESS",
		"UNIT_HEALTH",
		"UNIT_LEVEL",
		"UNIT_MANA",
		"UNIT_PET",
		"UNIT_PORTRAIT_UPDATE",
		"UNIT_RAGE",
		"UNIT_SPELLCAST_CHANNEL_START",
		"UNIT_SPELLCAST_CHANNEL_STOP",
		"UNIT_SPELLCAST_CHANNEL_UPDATE",
		"UNIT_SPELLCAST_DELAYED",
		"UNIT_SPELLCAST_FAILED",
		"UNIT_SPELLCAST_INTERRUPTED",
		"UNIT_SPELLCAST_START",
		"UNIT_SPELLCAST_STOP",
		"UNIT_SPELLCAST_SUCCEEDED",
		"UPDATE_FACTION",
		"UPDATE_INVENTORY_ALERTS",
		"UPDATE_SHAPESHIFT_FORMS",
		"VARIABLES_LOADED",
		"VOICE_START",
		"VOICE_STOP",
		"VOICE_PUSH_TO_TALK_START",
		"VOICE_PUSH_TO_TALK_STOP",
		"ZONE_CHANGED"
	}
	for __,v in pairs(events) do SpartanUI:RegisterEvent(v) end
end
-----------------------------------------------------------------------------------------------
--|	Purpose:	Initial cleanup and setup for SpartanUI										|--
-----------------------------------------------------------------------------------------------
function Sui_Setup()
	if not SUI_SelfFrame_Info_Buffs and suiData.buffToggle == "on" then
		Sui_BuffCreateFrames()
		BuffFrame:Hide()
		BuffFrame:SetAlpha(0)
		if TemporaryEnchantFrame then
			TemporaryEnchantFrame:Hide()
			TemporaryEnchantFrame:SetAlpha(0)
		end
	end
	SUI_HUD:SetFrameLevel(1)
	SetCVar("cameraDistanceMax","50")		-- Set the max cam distance to max
	SetCVar("cameraYawMoveSpeed","230")		-- Reset SpinCam in case of poor reload
	ChatFrame1:UnregisterEvent("TIME_PLAYED_MSG")
	RequestTimePlayed()
	QuestWatchFrame:ClearAllPoints()
	QuestWatchFrame:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -20, 200)
	QuestTimerFrame:ClearAllPoints()
	QuestTimerFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 250)
	DurabilityFrame:ClearAllPoints()
	DurabilityFrame:SetPoint("BOTTOM", "SUI_MapOverlay", "TOP", 0, 0)
	--Hide Unit frames and add redundancy for if SUI doesn't catch it fast enough
	PlayerFrame:UnregisterAllEvents()
	PlayerFrame:Hide()
	TargetFrame:UnregisterAllEvents()
	TargetFrame:Hide()
	PartyMemberFrame1:UnregisterAllEvents()
	PartyMemberFrame1:Hide()
	PartyMemberFrame2:UnregisterAllEvents()
	PartyMemberFrame2:Hide()
	PartyMemberFrame3:UnregisterAllEvents()
	PartyMemberFrame3:Hide()
	PartyMemberFrame4:UnregisterAllEvents()
	PartyMemberFrame4:Hide()
	MainMenuBar:Hide()
	hooksecurefunc("updateContainerFrameAnchors", Sui_Bags)
	hooksecurefunc("CaptureBar_Update", Sui_CaptureBar_Update)
	hooksecurefunc("UIParent_ManageFramePositions", Sui_ManageFrames)
	if ( BattlefieldMinimapTab and not BattlefieldMinimapTab:IsUserPlaced() ) then
		BattlefieldMinimapTab:ClearAllPoints()
		BattlefieldMinimapTab:SetPoint("TOP", "UIParent", "TOP", 0, 0)
	end
	Sui_ChatFrame("setup")
	Sui_LoadModules()
	Sui_MinimapFix()
	if suiData.autoresToggle == "on" then
		Sui_ResDetect()
	elseif suiData.autoresToggle == "off" then
		return
	end
	if suiData.popUps == "on" then
		SUI_PopLeft_Hit:Show()
		SUI_PopRight_Hit:Show()
	elseif suiData.popUps == "off" then
		SUI_PopLeft_Hit:Hide()
		SUI_PopRight_Hit:Hide()
	end
	if not ClickCastFrames then ClickCastFrames = {} end
	ClickCastFrames[SUI_Self_Button] = true
	ClickCastFrames[SUI_Target_Button] = true
	ClickCastFrames[SUI_Party1_Button] = true
	ClickCastFrames[SUI_Party2_Button] = true
	ClickCastFrames[SUI_Party3_Button] = true
	ClickCastFrames[SUI_Party4_Button] = true
	ClickCastFrames[SUI_Pet_Button] = true
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Command List																|--
-----------------------------------------------------------------------------------------------
function Sui_SlashCommand(msg)
	local msg, arg1, arg2 = strsplit(" ", msg)
	local msg = string.lower(msg)
	if msg == "" then
		Sui_HelpMenu()
	end
	if msg==SUIL.ENGLISH.UI.GODMODE or msg==SUI_Lang.UI.GODMODE then
		DEFAULT_CHAT_FRAME:AddMessage("Entering God Mode.", 1.0, 0, 0.0)
		DEFAULT_CHAT_FRAME:AddMessage("Now go beat up some Horde, "..UnitName("player")..".  :)", .5, .5, .5)
		godmode=1
	elseif msg=="fixres" then
		Sui_ResDetect()
	elseif msg == "autores" then								-- on by default
		if arg1=="on" then
			suiData.autoresToggle = "on"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: AutoUI Resize on - Please reload your UI.", 0.5, 0.5, 0.5)
		elseif arg1=="off" then
			suiData.autoresToggle = "off"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: AutoUI Resize off - Please reload your UI.", 0.5, 0.5, 0.5)
		end
	elseif msg==SUIL.ENGLISH.UI.VERSION or msg==SUI_Lang.UI.VERSION or msg=="vers" then
		local channel
		if arg1 then
			channel = "WHISPER"
		elseif UnitInRaid("player")then
			channel = "RAID"
		elseif GetNumPartyMembers() > 0 then
			channel = "PARTY"
		elseif GetGuildInfo("player") then
			channel = "GUILD"
		else
			channel = nil
		end
		if channel then
			local channelname = string.lower(channel)
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: version check broadcast to ".. channelname..".", 1, 0.75, 0)
			SendAddonMessage("SUI", "find "..UnitName("player").." version ".."current", channel, arg1 or UnitName("target"))
		else
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: version info only available for specific units, raid, or in-guild.", 0.65, 0.65, 0.65)
		end
	elseif msg=="lang" then
		if arg1=="english" or arg1==SUIL.ENGLISH.LANGUAGE then
			SUI_Lang = SUIL.ENGLISH
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="french" or arg1==SUIL.FRENCH.LANGUAGE then
			SUI_Lang = SUIL.FRENCH
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="greek" or arg1==SUIL.GREEK.LANGUAGE then
			SUI_Lang = SUIL.GREEK
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="italian" or arg1==SUIL.ITALIAN.LANGUAGE then
			SUI_Lang = SUIL.ITALIAN
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="swedish" or arg1==SUIL.SWEDISH.LANGUAGE then
			SUI_Lang = SUIL.SWEDISH
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="danish" or arg1==SUIL.DANISH.LANGUAGE then
			SUI_Lang = SUIL.DANISH
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="russian" or arg1==SUIL.RUSSIAN.LANGUAGE then
			SUI_Lang = SUIL.RUSSIAN
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="spanish" or arg1==SUIL.SPANISH.LANGUAGE then
			SUI_Lang = SUIL.SPANISH
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="korean" or arg1==SUIL.KOREAN.LANGUAGE then
			SUI_Lang = SUIL.KOREAN
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="norwegian" or arg1==SUIL.NORWEGIAN.LANGUAGE then
			SUI_Lang = SUIL.NORWEGIAN
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="german" or arg1==SUIL.GERMAN.LANGUAGE then
			SUI_Lang = SUIL.GERMAN
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		elseif arg1=="chinese" or arg1==SUIL.CHINESE.LANGUAGE then
			SUI_Lang = SUIL.TRADITIONAL_CHINESE
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI v"..suiData.dbVersion.." "..SUI_Lang.UI.LANGUAGE.." loaded.", 0.65, 0.65, 0.65)
		else
			DEFAULT_CHAT_FRAME:AddMessage(arg1.." language is not available.", 0.65, 0.65, 0.65)
		end
	elseif msg=="stats" then
		local channel
		if arg1 then
			channel = "WHISPER"
		elseif UnitInRaid("player")then
			channel = "RAID"
		elseif GetNumPartyMembers() > 0 then
			channel = "PARTY"
		elseif GetGuildInfo("player") then
			channel = "GUILD"
		else
			channel = nil
		end
		if channel then
			local channelname = string.lower(channel)
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: stat check broadcast to ".. channelname..".", 1, 0.75, 0)
			SendAddonMessage("SUI", "find "..UnitName("player").." performance ".."content", channel, arg1)
		else
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: stat info only available for specific units, raid, or in-guild.", 0.65, 0.65, 0.65)
		end
	elseif msg=="chatter" then
		Sui_Chatter(arg1)
	elseif msg=="event" then
		Sui_FindEvents(arg1)
	elseif msg=="children" then
		Sui_FindChildren(arg1)
	elseif msg=="conjure" then
		Sui_BuffConjure()
	elseif msg=="popup" then
		if arg1=="on" then								-- on by default
			suiData.popUps = "on"
			SUI_PopLeft_Hit:Show()
			SUI_PopRight_Hit:Show()
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Popups on.", 0.5, 0.5, 0.5)
		elseif arg1=="off" then
			suiData.popUps = "off"
			SUI_PopLeft_Hit:Hide()
			SUI_PopRight_Hit:Hide()
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Popups off.", 0.5, 0.5, 0.5)
		end
	elseif msg=="buff" or msg=="buffs" then							-- on by default
		if arg1=="off" then
			suiData.buffToggle = "off"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Buffs off - Please reload your UI.", 0.5, 0.5, 0.5)
			ReloadUI()
		elseif arg1=="on" then
			suiData.buffToggle = "on"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Buffs on - Please reload your UI.", 0.5, 0.5, 0.5)
			ReloadUI()
		end
	elseif msg=="party" then								-- on by default
		if arg1=="off" then
			suiData.partyToggle = "off"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Party Frames off.", 0.5, 0.5, 0.5)
		elseif arg1=="on" then
			suiData.partyToggle = "on"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Party Frames on.", 0.5, 0.5, 0.5)
		end
		Sui_UpdatePartyVisibility()
	elseif msg=="partyinraid" then								-- off by default
		if arg1=="on" then
			suiData.PartyInRaid = "on"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Party Frames while in RAID on.", 0.5, 0.5, 0.5)
		elseif arg1=="off" then
			suiData.PartyInRaid = "off"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Party Frames while in RAID off.", 0.5, 0.5, 0.5)
		end
		Sui_UpdatePartyVisibility()
	elseif msg=="help" then
		Sui_HelpMenu()
	elseif msg=="effect" then
		if arg1=="vignette" then
			FG_OnEvent("vignette")
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Effect Vignette *Toggled*.", 0.5, 0.5, 0.5)
		elseif arg1=="blur" then
			FG_OnEvent("film", "blur")
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Effect Film / Blur *Toggled*.", 0.5, 0.5, 0.5)
		elseif arg1=="crisp" then
			FG_OnEvent("film", "crisp")
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Effect Film / Crisp *Toggled*.", 0.5, 0.5, 0.5)
		end
	elseif msg=="icons" then
		if arg1=="color" then
			suiData.raidIcons = "Clean_Color"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Raid Icons set to Clean Color", 1, 0.75, 0)
			Sui_RaidIcon()
		elseif arg1=="grey" then
			suiData.raidIcons = "Clean_Grey"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Raid Icons set to Clean Grey", 1, 0.75, 0)
			Sui_RaidIcon()
		elseif arg1=="default" then
			suiData.raidIcons = "Default"
			DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Raid Icons set to default", 1, 0.75, 0)
			Sui_RaidIcon()
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Help menu/command list reference											|--
-----------------------------------------------------------------------------------------------
function Sui_HelpMenu(arg1)
	if not arg1 then
		DEFAULT_CHAT_FRAME:AddMessage("SpartanUI Help Menu:", 1, 0.75, 0)
		DEFAULT_CHAT_FRAME:AddMessage("Type /sui or /spartanui and then any of the following", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("*Denotes default setting", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("--------------------------------------------------", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffvers|r (Checks version of SUI)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffstats|r (Checks your game performance", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0fffixres|r (Runs screen res check manually)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffautores|r (Turns off autoui resize)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("--------------------------------------------------", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffchatter|r |c0000ffc0on/off|r (removes NPC chatter from chat)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0fficons|r |c0000ffc0color|r, |c0000ffc0grey|r, |c0000ffc0default*|r (Raid target icon markers)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffeffect|r |c0000ffc0vignette|r, |c0000ffc0blur|r, or |c0000ffc0crisp|r (Film effects for flare)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffpopup|r |c0000ffc0on/off|r (turns on the popup to cover stance/pet or micromenu bars)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffparty|r |c0000ffc0on/off|r (turn party frames on or off)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffpartyinraid|r |c0000ffc0on/off|r (automatically toggles party frames in raids)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffbuff|r (or buffs) |c0000ffc0on*/off|r (SUI buffs)", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("--------------------------------------------------", 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffAvailable languages:|r " .. (SUIL.AVAILABLE_LANGUAGES[1]), 0.75, 0.75, 0.75)
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0fflang|r |c0000ffc0X|r (Switch language to...)", 0.75, 0.75, 0.75)
	elseif msg == "lang" then
		DEFAULT_CHAT_FRAME:AddMessage("|c0000c0ffAvailable languages:|r " .. (SUIL.AVAILABLE_LANGUAGES[1]), 0.75, 0.75, 0.75)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Adapt, Flare  |--
-----------------------------------------------------------------------------------------------
function Sui_LoadModules()
	if (Adapt) then
		Adapt_Settings.Shape = "CIRCLE"
		Adapt.Reshape()
		Adapt_Settings.Backdrop = Adapt_Settings.Backdrop=="ON"
		Adapt.Reback()
	end
	if FEDB then
		if FEDB.animateGrainCrispy then
			FG_OnEvent("film", "crisp")
		end
		if FEDB.animateGrainFuzzy then
			FG_OnEvent("film", "blur")
		end
		if FEDB.vignette then
			FG_OnEvent("vignette")
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Adds additional info if MobInfo2 is present.				    |--
-----------------------------------------------------------------------------------------------
function Sui_MobInfo()
	if IsAddOnLoaded("MobInfo2") == 1 then
		local mobData = MI2_GetMobData(UnitName("target"), UnitLevel("target"), "target")
		if mobData ~= nil then
			local typeMob
			if UnitCreatureType("target") then
				if mobData.mobType == 3 then
					typeMob = " Boss "..UnitCreatureType("target")
				elseif mobData.mobType == 2 then
					typeMob = " Elite "..UnitCreatureType("target")
				else
					typeMob = " Mob "..UnitCreatureType("target")
				end
			end
			local rtn = "\r"
			local text = "|cffffc100"..UnitName("target").."|r\r"..UnitLevel("target")..typeMob..rtn..rtn.."Health: "..(mobData.healthMax or "_")..rtn.."Mana: "..(UnitManaMax("target") or "_")..rtn.."Damage: "..(mobData.minDamage or "_").." - "..(mobData.maxDamage or "_")..rtn.."XP: "..(mobData.xp or "_")
			SUI_MouseTooltip_Text:SetText(text)
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Repositions bags for HUD offset.					    |--
-----------------------------------------------------------------------------------------------
function Sui_Bags()
	-- Global Settings
	VISIBLE_CONTAINER_SPACING = 3
	CONTAINER_OFFSET_Y = 170
	CONTAINER_OFFSET_X = 20
	CONTAINER_SCALE = 0.90
	-- Adjust the start anchor for bags
	local shrinkFrames, frame;
	local xOffset = CONTAINER_OFFSET_X;
	local yOffset = CONTAINER_OFFSET_Y;
	local screenHeight = GetScreenHeight();
	local containerScale = CONTAINER_SCALE;
	local freeScreenHeight = screenHeight - yOffset;
	local index = 1;
	local column = 0;
	local uiScale = 1;
	if ( GetCVar("useUiScale") == "1" ) then
		uiScale = GetCVar("uiscale") + 0;
		if ( uiScale > containerScale ) then
			containerScale = uiScale * containerScale;
		end
	end
	while ContainerFrame1.bags[index] do
		frame = getglobal(ContainerFrame1.bags[index]);
		ContainerFrame1:ClearAllPoints()
		frame:SetScale(1);
		-- freeScreenHeight determines when to start a new column of bags
		if ( index == 1 ) then
			-- First bag
			frame:SetPoint("BOTTOMRIGHT", "SpartanUI", "BOTTOMRIGHT", -xOffset, yOffset );
		elseif ( freeScreenHeight < frame:GetHeight() ) then
			-- Start a new column
			column = column + 1;
			freeScreenHeight = screenHeight - yOffset;
			frame:SetPoint("BOTTOMRIGHT", "SpartanUI", "BOTTOMRIGHT", -(column * CONTAINER_WIDTH) - xOffset, yOffset );
		else
			-- Anchor to the previous bag
			frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);
		end
		if ( frame:GetLeft() < ( BankFrame:GetRight() - 45 ) ) then
			if ( frame:GetTop() > ( BankFrame:GetBottom() + 50 ) ) then
				shrinkFrames = 1;
				break;
			end
		end
		freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
		index = index + 1;
	end
	if ( shrinkFrames ) then
		screenHeight = screenHeight / containerScale;
		xOffset = xOffset / containerScale;
		yOffset = yOffset / containerScale;
		freeScreenHeight = screenHeight - yOffset;
		index = 1;
		column = 0;
		while ContainerFrame1.bags[index] do
			frame = getglobal(ContainerFrame1.bags[index]);
			ContainerFrame1:ClearAllPoints()
			frame:SetScale(containerScale);
			if ( index == 1 ) then
				-- First bag
				frame:SetPoint("BOTTOMRIGHT", "SpartanUI", "BOTTOMRIGHT", -xOffset, yOffset );
			elseif ( freeScreenHeight < frame:GetHeight() ) then
				-- Start a new column
				column = column + 1;
				freeScreenHeight = screenHeight - yOffset;
				frame:SetPoint("BOTTOMRIGHT", "SpartanUI", "BOTTOMRIGHT", -(column * CONTAINER_WIDTH) - xOffset, yOffset );
			else
				-- Anchor to the previous bag
				frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);
			end
			freeScreenHeight = freeScreenHeight - frame:GetHeight() - VISIBLE_CONTAINER_SPACING;
			index = index + 1;
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Hooked Blizz code. Moves items like the quest frame to fit the new layout   |--
-----------------------------------------------------------------------------------------------
function Sui_ManageFrames()
	-- Global Settings
	local CONTAINER_OFFSET_X = 8
	local anchorY = 20
	-- Quest timers
	QuestTimerFrame:ClearAllPoints()
	QuestTimerFrame:SetPoint("TOPRIGHT", "QuestWatchFrame", "BOTTOMRIGHT", -CONTAINER_OFFSET_X, anchorY);
	if ( QuestTimerFrame:IsShown() ) then
		anchorY = anchorY - QuestTimerFrame:GetHeight();
	end
	-- Durability frame
	DurabilityFrame:ClearAllPoints()
	if ( DurabilityFrame ) then
		local durabilityOffset = 0;
		if ( DurabilityShield:IsShown() or DurabilityOffWeapon:IsShown() or DurabilityRanged:IsShown() ) then
			durabilityOffset = 20;
		end
		DurabilityFrame:SetPoint("TOPRIGHT", "QuestWatchFrame", "BOTTOMRIGHT", -CONTAINER_OFFSET_X-durabilityOffset, anchorY);
		if ( DurabilityFrame:IsShown() ) then
			anchorY = anchorY - DurabilityFrame:GetHeight();
		end
	end
	QuestWatchFrame:ClearAllPoints()
	QuestWatchFrame:SetPoint("TOPRIGHT", "SpartanUI", "TOPRIGHT", -CONTAINER_OFFSET_X, -anchorY);
	-- Hide PetBar Grid when a Pet isn't active
	local _, englishClass = UnitClass("player")
	if englishClass == "HUNTER" or englishClass == "WARLOCK" then
		PetActionBar_ShowGrid()
	end
	-- This hooks into Blizzards "Always Show ActionBars" setting. If you don't want the Grid on your Actionbars
	-- then turn off this setting in your Interface Options.
	MultiActionBar_UpdateGridVisibility()
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Should fix the PvP capture bar and setup BattlefieldMinimap		    |--
-----------------------------------------------------------------------------------------------
function Sui_CaptureBar_Update()
	if ( NUM_EXTENDED_UI_FRAMES ) then
		local capbar
		local numCaptureBars = 0
		for i = 1, NUM_EXTENDED_UI_FRAMES do
			local capbar = getglobal("WorldStateCaptureBar"..i)
			if ( capbar and capbar:IsShown() ) then
			capbar:SetPoint("BOTTOMRIGHT", "QuestWatchFrame", "TOPRIGHT", -CONTAINER_OFFSET_X, anchorY)
				anchorY = anchorY - captureBar:GetHeight()
			end
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Sets up the minimap for use with SUI layout.				    |--
-----------------------------------------------------------------------------------------------
function Sui_MinimapFix()
	MinimapBorderTop:Hide()
	MinimapToggleButton:Hide()
	MinimapBorder:Hide()
	Minimap:SetHeight(146)
	Minimap:SetWidth(146)
	Minimap:ClearAllPoints()
	Minimap:SetPoint("CENTER", "SUI_MapOverlay", "CENTER", 0, 0)
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetMovable(true)
	MinimapCluster:SetUserPlaced(true)
	MinimapCluster:ClearAllPoints()
	MinimapCluster:SetPoint("CENTER", "SUI_MapOverlay", "CENTER", -10, -4)
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetParent(Minimap)
	MinimapZoneText:SetPoint("BOTTOM", "SUI_MapOverlay", "BOTTOM", 0, 24)
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("BOTTOM", "MinimapZoneText", "BOTTOM", 0, 0)
	-- Fix for evil UiScale vs SuiScale (/sui maxres)
	local point, relativeTo, relativePoint, xOfs, yOfs = MinimapZoomIn:GetPoint()
	MinimapZoomIn:SetParent(Minimap)
	MinimapZoomIn:SetFrameLevel(5)
	MinimapZoomIn:SetPoint(point, "Minimap", relativePoint, 73, -33)
	local point, relativeTo, relativePoint, xOfs, yOfs = MinimapZoomOut:GetPoint()
	MinimapZoomOut:SetParent(Minimap)
	MinimapZoomOut:SetFrameLevel(5)
	MinimapZoomOut:SetPoint(point, "Minimap", relativePoint, 38, -68)
	local point, relativeTo, relativePoint, xOfs, yOfs = MiniMapTracking:GetPoint()
	MiniMapTracking:SetParent(Minimap)
	MiniMapTracking:SetFrameLevel(5)
	MiniMapTracking:SetFrameStrata("HIGH")
	MiniMapTracking:SetPoint(point, "Minimap", relativePoint, -8, 4)

	local point, relativeTo, relativePoint, xOfs, yOfs = MiniMapWorldMapButton:GetPoint()
	MiniMapWorldMapButton:SetParent(Minimap)
	MiniMapWorldMapButton:SetFrameLevel(5)
	MiniMapWorldMapButton:SetFrameStrata("HIGH")
	MiniMapWorldMapButton:SetPoint(point, "Minimap", relativePoint, 18, 18)


	GameTimeFrame:SetScale(0.85)
	local point, relativeTo, relativePoint, xOfs, yOfs = GameTimeFrame:GetPoint()
	GameTimeFrame:SetParent(Minimap)
	GameTimeFrame:SetFrameLevel(5)
	GameTimeFrame:SetFrameStrata("HIGH")
	GameTimeFrame:SetPoint(point, "Minimap", relativePoint, 8, 8)
	SUI_MinimapCoords:SetWidth(100)
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Chat frame configuration. Shifts chat entry to top of window & moves	    |--
--|		scroll/emote buttons to the right and handles toggling of it on/off	    |--
--|  Arguments:	task = "setup", "hide", "show"						    |--
-----------------------------------------------------------------------------------------------
function Sui_ChatFrame(task)
	local i
	if task == "setup" then
		for i = 1, 7, 1 do
			getglobal("ChatFrame"..i):SetFrameStrata("LOW")
			getglobal("ChatFrame"..i.."BottomButton"):SetPoint("BOTTOMLEFT", ("ChatFrame"..i), "BOTTOMRIGHT", -32, -4)
		end
		ChatFrameEditBox:ClearAllPoints()
		ChatFrameEditBox:SetPoint("BOTTOMLEFT", "ChatFrame1", "TOPLEFT", 0, 2)
		ChatFrameEditBox:SetPoint("BOTTOMRIGHT", "ChatFrame1", "TOPRIGHT", 0, 2)
		ChatFrameMenuButton:SetFrameStrata("DIALOG")
		for i = 1, 7, 1 do
			getglobal("ChatFrame"..i.."BottomButton"):SetScale(0.8)
			getglobal("ChatFrame"..i.."DownButton"):SetScale(0.8)
			getglobal("ChatFrame"..i.."UpButton"):SetScale(0.8)
		end
		ChatFrameMenuButton:SetScale(0.8)
	elseif task == "hide" then
		for i = 1, 7, 1 do
			getglobal("ChatFrame"..i.."UpButton"):SetAlpha(0)
			getglobal("ChatFrame"..i.."DownButton"):SetAlpha(0)
			getglobal("ChatFrame"..i.."BottomButton"):SetAlpha(0)
		end
		ChatFrameMenuButton:SetAlpha(0)
	elseif task == "show" then
		for i = 1, 7, 1 do
			getglobal("ChatFrame"..i.."UpButton"):SetAlpha(1)
			getglobal("ChatFrame"..i.."DownButton"):SetAlpha(1)
			getglobal("ChatFrame"..i.."BottomButton"):SetAlpha(1)
		end
		ChatFrameMenuButton:SetAlpha(1)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Bartender Setup. Shortly will be outdated.									|--
--|  Arguments:	task = "source", "dest"														|--
-----------------------------------------------------------------------------------------------
local function tblMerge(source, dest)
	if type(source) ~= "table" then return end
	if type(dest) ~= "table" then dest = {} end
	for k,v in pairs(source) do
		if type(v) ~= "table" then
			dest[k] = v
		else
			dest[k] = tblMerge(v, dest[k])
		end
	end
	return dest
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Bartender4 stored layout for SpartanUI.  Runs after load screen every time.			|--
-----------------------------------------------------------------------------------------------
function Sui_Bartender()
	MainMenuBar:Hide()
	MultiBarBottomLeft:Hide()
	MultiBarBottomRight:Hide()
	MultiBarLeft:Hide()
	MultiBarRight:Hide()
		Bartender4.db:SetProfile("Default")
		local default = "SpartanUI Standard"
		local userprofile = UnitName("player").." - "..GetRealmName()
		local action_bars = {
			actionbars = {
				[1] = {
					enabled = true,
					showgrid = true,
					hidemacrotext = true,
					scale = 0.81,
					rows = 1,
					alpha = 1,
					position = {
						x = -65,
						y = 46,
						point = "BOTTOMRIGHT",
						relPoint = "BOTTOM",
					},
					padding = "5",
					skin = { Zoom = true, },
				},
				[2] = {
					scale = 1,
					rows = 1,
					skin = { Zoom = false },
					enabled = false,
					fadeoutdelay = 0.2,
				},
				[3] = {
					enabled = true,
					showgrid = true,
					hidemacrotext = true,
					scale = 0.81,
					rows = 1,
					alpha = 1,
					position = {
						x = -65,
						y = 20,
						point = "BOTTOMRIGHT",
						relPoint = "BOTTOM",
					},
					padding = "5",
					skin = { Zoom = true, },
					},
				[4] = {
					enabled = true,
					showgrid = true,
					hidemacrotext = true,
					scale = 0.81,
					rows = 1,
					alpha = 1,
					position = {
						x = 65,
						y = 46,
						point = "BOTTOMLEFT",
						relPoint = "BOTTOM",
					},
					padding = "5",
					skin = { Zoom = true, },
					},
				[5] = {
					enabled = true,
					showgrid = true,
					hidemacrotext = true,
					scale = 0.81,
					rows = 1,
					alpha = 1,
					position = {
						x = 65,
						y = 20,
						point = "BOTTOMLEFT",
						relPoint = "BOTTOM",
					},
					padding = "5",
					skin = { Zoom = true, },
					},
				[6] = {
					enabled = true,
					showgrid = true,
					hidemacrotext = true,
					scale = 0.81,
					rows = 3,
					alpha = 1,
					position = {
						x = -358,
						y = 4,
						point = "BOTTOMRIGHT",
						relPoint = "BOTTOM",
					},
					padding = 5,
					skin = { Zoom = true, },
					},
				[7] = { enabled = false },
				[8] = { enabled = false },
				[9] = { enabled = false },
				[10] = {
					enabled = true,
					showgrid = true,
					hidemacrotext = true,
					scale = 0.81,
					rows = 3,
					position = {
						x = 358,
						y = 4,
						point = "BOTTOMLEFT",
						relPoint = "BOTTOM",
					},
					padding = 5,
					skin = { Zoom = true, },
				},
			},
		}
		local micro_menu = {
			scale = 0.8,
			alpha = 1,
			position = {
				y = 67,
				x = 67,
				point = "BOTTOMLEFT",
				relPoint = "BOTTOM",
			},
		}
		local bag_bar = {
			scale = 0.72,
			rows = 1,
			alpha = 1,
			padding = 2,
			keyring = true,
			skin = { Zoom = false },
			position = {
				y = 75,
				x = 344,
				point = "BOTTOMRIGHT",
				relPoint = "BOTTOM",
			},
		}
		local stance_bar = {
			scale = 0.85,
			padding = 5,
			skin = { Zoom = true, },
			position = {
				y = 75,
				x = -324,
				point = "BOTTOMLEFT",
				relPoint = "BOTTOM",
			},
		}
		local pet_bar = {
			scale = 0.85,
			rows = 1,
			alpha = 1,
			skin = { Zoom = true },
			padding = 5,
			position = {
				y = 75,
				x = -95,
				point = "BOTTOMRIGHT",
				relPoint = "BOTTOM",
			},
		}
		Bartender4.db.children.ActionBars.profiles[default] = action_bars
		Bartender4.db.sv.profiles[default] = {}
		Bartender4.db.children.BagBar.profiles[default] = bag_bar
		Bartender4.db.children.PetBar.profiles[default] = pet_bar
		Bartender4.db.children.StanceBar.profiles[default] = stance_bar
		Bartender4.db.children.MicroMenu.profiles[default] = micro_menu
		Bartender4.db:SetProfile(default)
	Sui_BarFix()
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Bartender4 re-anchors its frames after each setup.  This detaches them and	|--
--|				places them in their correct positions (if they exist).						|--
-----------------------------------------------------------------------------------------------
function Sui_BarFix()
	local frame = BartenderPlate or CreateFrame("Frame","BartenderPlate", SpartanUI)
	frame:SetFrameStrata("LOW")
	frame:SetWidth(2)
	frame:SetHeight(1)
	frame:SetPoint("BOTTOM",0,0)
	frame:Show()
	if BT4Bar1 then
		SUI_Bar1_BG:ClearAllPoints()
		SUI_Bar1_BG:Show()
		SUI_Bar1_BG:SetPoint("BOTTOMLEFT", "BT4Bar1", "BOTTOMLEFT", -55, -15)
		BT4Bar1:SetParent(frame)
	else
		SUI_Bar1_BG:Hide()
	end
	if BT4Bar3 then
		SUI_Bar2_BG:ClearAllPoints()
		SUI_Bar2_BG:Show()
		SUI_Bar2_BG:SetPoint("BOTTOMLEFT", "BT4Bar3", "BOTTOMLEFT", -55, -15)
		BT4Bar3:SetParent(frame)
	else
		SUI_Bar2_BG:Hide()
	end
	if BT4Bar4 then
		SUI_Bar3_BG:ClearAllPoints()
		SUI_Bar3_BG:Show()
		SUI_Bar3_BG:SetPoint("BOTTOMLEFT", "BT4Bar4", "BOTTOMLEFT", -55, -15)
		BT4Bar4:SetParent(frame)
	else
		SUI_Bar3_BG:Hide()
	end
	if BT4Bar5 then
		SUI_Bar4_BG:ClearAllPoints()
		SUI_Bar4_BG:Show()
		SUI_Bar4_BG:SetPoint("BOTTOMLEFT", "BT4Bar5", "BOTTOMLEFT", -55, -15)
		BT4Bar5:SetParent(frame)
	else
		SUI_Bar4_BG:Hide()
    end
	if BT4Bar6 then
		SUI_Bar5_BG:ClearAllPoints()
		SUI_Bar5_BG:Show()
		SUI_Bar5_BG:SetPoint("CENTER", "BT4Bar6", "CENTER", 1, -1)
		BT4Bar6:SetParent(frame)
	else
		SUI_Bar5_BG:Hide()
    end
	if BT4Bar10 then
		SUI_Bar6_BG:ClearAllPoints()
		SUI_Bar6_BG:Show()
		SUI_Bar6_BG:SetPoint("CENTER", "BT4Bar10", "CENTER", 1, -1)
		BT4Bar10:SetParent(frame)
	else
		SUI_Bar6_BG:Hide()
	end
	if BT4BarMicroMenu then
		BT4BarMicroMenu:SetParent(frame)
		if not SUI_BT4 then
			BT4BarMicroMenu:SetPoint("BOTTOMLEFT", frame, "BOTTOM", 133, 130)
		end
	end
	if BT4BarBagBar then
		BT4BarBagBar:SetParent(frame)
		BT4BarBagBar:SetFrameStrata("LOW")
		KeyRingButton:SetScale(.96)
		MainMenuBarBackpackButton:SetScale(1)
		if not SUI_BT4 then
			BT4BarBagBar:SetPoint("LEFT", BT4BarMicroMenu, "RIGHT", 34, -20)
		end
	end
	if BT4BarPetBar then
		BT4BarPetBar:SetParent(frame)
	end
	if BT4BarStanceBar then
		BT4BarStanceBar:SetParent(frame)
	end
	if not BT4BarMicroMenu and not BT4BarBagBar then
		SUI_BarPoppupRight_BG:Hide()
	else
		SUI_BarPoppupRight_BG:Show()
	end
	if not BT4BarStanceBar and not BT4BarPetBar then
		SUI_BarPoppupLeft_BG:Hide()
	else
		SUI_BarPoppupLeft_BG:Show()
	end
	if BT4BarXP then
		BT4BarXP:Hide()
	end
	frame:SetParent(SpartanUI)
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Dropdown Menus & Click-targeting.											|--
-----------------------------------------------------------------------------------------------
function Sui_Dropdown_Setup(self, dropdown, unit)
	local showmenu = function()
		ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0) --self:GetName(), 106, 27)
	end
	SecureUnitButton_OnLoad(self, unit, showmenu)
end

function Sui_PartyFrame_OnLoad()
	this:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	local showmenu = function()
		ToggleDropDownMenu(1, nil, getglobal("SUI_Party"..this:GetID().."_DropDown"), "cursor", 0, 0) --this:GetName(), 47, 15);
	end
	SecureUnitButton_OnLoad(this, "party"..this:GetID(), showmenu);
end

function Sui_PartyFrameDropDown_OnLoad()
	UIDropDownMenu_Initialize(this, Sui_PartyFrameDropDown_Initialize, "MENU");
end

function Sui_PartyFrameDropDown_Initialize()
	local dropdown;
	if ( UIDROPDOWNMENU_OPEN_MENU ) then
		dropdown = getglobal(UIDROPDOWNMENU_OPEN_MENU);
	else
		dropdown = this;
	end
	UnitPopup_ShowMenu(dropdown, "PARTY", "party"..dropdown:GetParent():GetID());
end

function Sui_Self_DropDown_Initialize()
	UnitPopup_ShowMenu(SUI_Self_DropDown, "SELF", "player", nil, nil)
end

function Sui_Pet_DropDown_Initialize()
	UnitPopup_ShowMenu(SUI_Pet_DropDown, "PET", "pet", nil, nil)
end

function SUI_Focus_DropDown_Initialize()
	-- UnitPopup_ShowMenu(SUI_Focus_DropDown, "FOCUS", "focus")
end

function Sui_Target_DropDown_Initialize()
	local menu
	local name
	local id = nil
	if ( UnitIsUnit("target", "player") ) then
		menu = "SELF"
	elseif ( UnitIsUnit("target", "pet") ) then
		menu = "PET"
	elseif ( UnitIsPlayer("target") ) then
		id = UnitInRaid("target")
		if ( id ) then
			menu = "RAID_PLAYER"
			name = GetRaidRosterInfo(id +1)
		elseif ( UnitInParty("target") ) then
			menu = "PARTY"
		else
			menu = "PLAYER"
		end
	else
		menu = "RAID_TARGET_ICON"
		name = RAID_TARGET_ICON
	end
	if ( menu ) then
		UnitPopup_ShowMenu(SUI_Target_DropDown, menu, "target", name, id)
	end
end

function Sui_TOT_DropDown_Initialize()
	local menu
	local name
	local id = nil
	if ( UnitIsUnit("targettarget", "player") ) then
		menu = "SELF"
	elseif ( UnitIsUnit("targettarget", "pet") ) then
		menu = "PET"
	elseif ( UnitIsPlayer("targettarget") ) then
		id = UnitInRaid("targettarget")
		if ( id ) then
			menu = "RAID_PLAYER"
			name = GetRaidRosterInfo(id +1)
		elseif ( UnitInParty("target") ) then
			menu = "PARTY"
		else
			menu = "PLAYER"
		end
	else
		menu = "RAID_TARGET_ICON"
		name = RAID_TARGET_ICON
	end
	if ( menu ) then
		UnitPopup_ShowMenu(SUI_ToT_DropDown, menu, "target", name, id)
	end
end

function Sui_Self_OnReceiveDrag()
	if ( CursorHasItem() ) then
		AutoEquipCursorItem()
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Displays unit frame tooltips.												|--
--|	 Arguments:	job: enter or exit															|--
--|				toon: the unit to display tooltip info for									|--
-----------------------------------------------------------------------------------------------
function Sui_UnitTooltip(job, toon)
	if job=="enter" then
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    	GameTooltip:SetUnit(toon)
    	GameTooltip:Show()
	elseif job=="exit" then
		GameTooltip:Hide()
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Generic function for determining and setting the class icon for a unit.		|--
--|  Arguments:	toon = "player", "party1", etc...											|--
--|				texture = name of the healthbar texture object								|--
--|				scale = size of the icon in pixels you want it to be displayed at.			|--
-----------------------------------------------------------------------------------------------
local classIcons = {};
	classIcons["WARRIOR"] = {1,1};
	classIcons["MAGE"] = {1,2};
	classIcons["ROGUE"] = {1,3};
	classIcons["DRUID"] = {1,4};
	classIcons["HUNTER"] = {2,1};
	classIcons["SHAMAN"] = {2,2};
	classIcons["PRIEST"] = {2,3};
	classIcons["WARLOCK"] = {2,4};
	classIcons["PALADIN"] = {3,1};
	classIcons["DEATHKNIGHT"] = {3,2};
	classIcons["DEFAULT"] = {4,4}; -- transparent so hidden by default

function Sui_ClassIcon(toon, texture, scale) -- scale is now a legacy value
-- TODO: remove all references to scale in Sui_ClassIcon calls since it is no longer used
	if (not texture) then return; end
	local _,class = UnitClass(toon);
	if (not class) then class = "DEFAULT"; end
	local row,col = classIcons[class][1],classIcons[class][2];
	local left,top = (col-1)*0.25,(row-1)*0.25;
	texture:SetTexCoord(left,left+0.25,top,top+0.25);
	texture:Show();
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Determines and sets the raid target icons on units.	Since there are			|--
--|				no args from RAID_TARGET_UPDATE, we cycle through the units.				|--
-----------------------------------------------------------------------------------------------
function Sui_RaidIcon()
	local iconFile, top = "Interface\\TargetingFrame\\UI-RaidTargetingIcons", 0;
	if (suiData.raidIcons ~= "Default") then
		iconFile = "Interface\\AddOns\\SpartanUI\\Textures\\Icon_RaidTargets";
	end
	if (suiData.raidIcons == "Clean_Grey") then
		top = 0.5;
	end
	for i = 1, 10 do -- cycle through our 10 relevant unit frames
		local iconNum = GetRaidTargetIndex(suiData.unit[i].unit);
		local icon = _G[suiData.unit[i].frame.."_RaidIcon"];
		if (iconFile and iconNum and icon) then
			local iconLeft = 0;
			if (iconNum > 4) then
				iconLeft, top = 4, top + 0.25;
			end
			local right = (iconNum - iconLeft) / 4;
			if (icon.kind ~= suiData.raidIcons) then
				icon:SetTexture(iconFile);
				icon.kind = suiData.raidIcons;
			end
			icon:SetTexCoord(right-0.25,right,top,top+0.25);
			icon:Show();
		elseif (icon and icon:IsVisible()) then
			icon:Hide();
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Generic function for determining and setting the health for unit frames.	|--
--|  Arguments:	toon = "player", "party1", etc...											|--
--|  			barwidth = width of healthbar												|--
--|				percent = name of percentage fontstring										|--
--|				count = name of healthcount fontstring										|--
--|				deficit = name of deficit fontstring										|--
--|				texture = name of the healthbar texture object								|--
-----------------------------------------------------------------------------------------------
function Sui_HealthMath(toon, barwidth, barheight, father)
	-- Name your objects
	local texture = _G[father.."_HealthBar"]
	local percent = _G[father.."_HealthPercentage"]
	local count = _G[father.."_HealthCount"]
	local deficit = _G[father.."_HealthDeficit"]
	-- Divide the current player health by the max, ergo pertentage.
	-- Round the percentage to 0 decimals.
	local toon_Health = (UnitHealth(toon) / UnitHealthMax(toon)) * 100
    local healthPercent = math.floor(toon_Health+0.5)
	-- Populate strings
	if not percent then return end
	percent:SetText(healthPercent.."%")
	count:SetText(UnitHealth(toon))
	deficit:SetText(UnitHealthMax(toon) - UnitHealth(toon))
	-- Hide count if target health is unretrievable
    if UnitHealthMax(toon)==100 then
    	count:Hide()
    	deficit:Hide()
    else
    	count:Show()
    	deficit:Show()
    end
    -- Populate with MobInfo if available
    if toon=="target" and IsAddOnLoaded("MobInfo2")==1 then
    	local mobData = MI2_GetMobData( UnitName("target"), UnitLevel("target"), "target" )
    	if mobData~=nil then
    		count:Show()
    		count:SetText(mobData.healthCur)
    		deficit:SetText(mobData.healthMax - mobData.healthCur)
   		end
    end
    -- Hide deficit if there is none
    if (UnitHealthMax(toon) == UnitHealth(toon)) then
    	deficit:Hide()
   	else
    	deficit:Show()
    end
    if not texture.barheight then
	    texture.barheight = (barheight * 16)
	    texture.barwidth = (barwidth * 3.2)
    end
    if texture then
		texture:Show()
	end
	-- Pass off global info
	local toonID = Sui_DeriveUnit(toon, "number", 10)
	if not toonID then return end
	suiData.unit[toonID].HealthPercent = healthPercent
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Generic function for determining and setting the power for unit frames		|--
--|  Arguments: same as Sui_HealthMath except this time with power							|--
-----------------------------------------------------------------------------------------------
function Sui_PowerMath(toon, barwidth, barheight, father)
	-- Test for power type and configure texture accordingly
	local power, texture2, texture3, texture4
	if UnitPowerType(toon)==0 then
   		power = "Mana"
   		texture2 = _G[father.."_RageBar"]
   		texture3 = _G[father.."_EnergyBar"]
   		texture4 = _G[father.."_FocusBar"]
   	elseif UnitPowerType(toon)==1 then
   		power = "Rage"
   		texture2 = _G[father.."_ManaBar"]
   		texture3 = _G[father.."_EnergyBar"]
   		texture4 = _G[father.."_FocusBar"]
   	elseif UnitPowerType(toon)==2 then
   		power = "Focus"
   		texture2 = _G[father.."_RageBar"]
   		texture3 = _G[father.."_EnergyBar"]
   		texture4 = _G[father.."_ManaBar"]
   	elseif UnitPowerType(toon)==3 then
   		power = "Energy"
   		texture2 = _G[father.."_RageBar"]
   		texture3 = _G[father.."_ManaBar"]
   		texture4 = _G[father.."_FocusBar"]
   	end
	-- Name your objects
	local texture = _G[father.."_"..power.."Bar"]
	local percent = _G[father.."_ManaPercentage"]
	local count = _G[father.."_ManaCount"]
	local deficit = _G[father.."_ManaDeficit"]
	-- Divide the current player power by the max, ergo pertentage.
	-- Round the percentage to 0 decimals.
	local power = (UnitMana(toon) / UnitManaMax(toon)) * 100
    local powerPercent = math.floor(power+0.5) + 0
    if UnitMana(toon)==0 then
    	powerPercent=0
    end
    if not percent then return end
    percent:SetText(powerPercent.."%")
    count:SetText(UnitMana(toon))
    deficit:SetText(UnitManaMax(toon) - UnitMana(toon))
    -- Only show the deficit if there is one
    if (UnitManaMax(toon) == UnitMana(toon)) then
    	deficit:Hide()
    else
    	deficit:Show()
    end
   	if texture and not texture.barheight then
	    texture.barheight = (barheight * 16)
	    texture.barwidth = (barwidth * 3.2)
    end
	if not texture:IsVisible() then
		if texture then
			texture:Show()
		end
		if texture2 then
			texture2:Hide()
		end
		if texture3 then
			texture3:Hide()
		end
		if texture4 then
			texture4:Hide()
		end
	end
	-- Pass off global info
	local toonID = Sui_DeriveUnit(toon, "number", 10)
	if not toonID then return end
	suiData.unit[toonID].PowerPercent = powerPercent
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Generic function for animating cast bars.									|--
--|  Arguments:	toon = "player", "party1", etc...											|--
--|  			spell = name of the spell being cast										|--
--|				rank = name of the rank (literally ie., "Rank 7")							|--
--|  Logic:		Takes the cast-time of the current spell, and based on the time it started	|--
--|				will determine what percent of the cast has transpired based on the current |--
--|				time.																		|--
-----------------------------------------------------------------------------------------------
function Sui_CastMath(toon, spell, rank, barwidth, barheight, texture)
	local startTime, endTime, spellName
	_, _, SUI_lag = GetNetStats()
	local toonID = Sui_DeriveUnit(toon, "number", 10)
	if not toonID then return end
	if suiData.unit[toonID].isCasting==1 then
		spell, rank, spellName, _, startTime, endTime = UnitCastingInfo(toon)
		if not endTime then
			suiData.unit[toonID].isCasting=0
		else
			suiData.unit[toonID].spellDuration = (endTime - startTime)/1000
			suiData.unit[toonID].spellEnd = endTime/1000
		end
	end
	if suiData.unit[toonID].isChanneling==1 then
		spell, rank, spellName, _, startTime, endTime = UnitChannelInfo(toon)
		if not endTime then
			suiData.unit[toonID].isChanneling=0
		else
			suiData.unit[toonID].spellDuration = (endTime - startTime)/1000
			suiData.unit[toonID].spellEnd = endTime/1000
		end
	end
	if not texture then return end
	if not texture:IsVisible() then
		texture:Show()
	end
	if not texture.barheight then
		texture.barheight = (barheight * 16)
		texture.barwidth = (barwidth * 3.2)
	end
	if type(spell)=="string" then
		_G[suiData.unit[toonID].frame .. "_CastText"]:SetText(spell)
		_G[suiData.unit[toonID].frame .. "_CastText"]:Show()
		_G[suiData.unit[toonID].frame .. "_CastTime"]:SetText(suiData.unit[toonID].spellDuration)
		_G[suiData.unit[toonID].frame .. "_CastTime"]:Show()
	end
	if toonID==1 then
		_G[suiData.unit[toonID].frame .. "_CastLatency"]:SetText(SUI_lag)
		_G[suiData.unit[toonID].frame .. "_CastLatency"]:Show()
	end
	_G[suiData.unit[toonID].frame .. "_CastBar_Latency"]:SetAlpha(.5)
	if not suiData.unit[toonID].isCasting then
		suiData.unit[toonID].isCasting = 0
	end
	if not suiData.unit[toonID].isChanneling then
		suiData.unit[toonID].isChanneling = 0
	end
	if suiData.unit[toonID].isCasting==0 and suiData.unit[toonID].isChanneling==0 then
		Sui_Animation(suiData.unit[toonID].unit, "Cast", suiData.unit[toonID].frame .. "_CastBar", suiData.unit[toonID].castbar_width, suiData.unit[toonID].castbar_height, suiData.unit[toonID].direction, 1, toonID)
	end
end

function Sui_InitCastMath(toon, spell, rank, wildcard, value)
	local toonID = Sui_DeriveUnit(toon, "number", 9)
	if not toonID then return end
	if (toonID<=6 or toonID==9) and (suiData.unit[toonID][wildcard]==1 and value==0) or value==1 then
		suiData.unit[toonID][wildcard] = value
		Sui_CastMath(toon, spell, rank, suiData.unit[toonID].castbar_width, suiData.unit[toonID].castbar_height, _G[suiData.unit[toonID].frame.."_CastBar"])
	elseif toonID==2 then
		suiData.unit[toonID][wildcard] = value
		Sui_CastMath(toon, spell, rank, suiData.unit[toonID].castbar_width, suiData.unit[toonID].castbar_height, _G[suiData.unit[toonID].frame.."_CastBar"])
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Determines actual game time in milliseconds(Blizzard doesnt provide this).  |--
--|  Arguments:	toon = "player", "party1", etc...											|--
--|  Returns:	game time in milliseconds upshifted to seconds decimal (ie., 12345.678)		|--
--|	 Logic:		If you called GetTime(), it gives you system time. So if you				|--
--|	 			wanted to find how much time till X spell was finished, youd have to know   |--
--|	 			the difference between GetTime() and spellEnd								|--
-----------------------------------------------------------------------------------------------
function GameTime(toon)
	if not suiData.timeDisparity then
		local spellName, startTime, endTime
		spellName, _, _, _, startTime, endTime, other = UnitCastingInfo(toon)
		if not endTime then
			spellName, _, _, _, startTime, endTime, other = UnitChannelInfo(toon)
		end
		if not startTime then return end
		suiData.timeDisparity = startTime/1000 - GetTime()
	end
	if not suiData.timeDisparity then return end
	local GameTime = suiData.timeDisparity + GetTime()
	return GameTime
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Generic function for animating bars.										|--
--|  Arguments: toon = player, partyN, target, etc.											|--
--|				kind = "Health" or "Power" or "Cast"										|--
--|				texture = target texture name												|--
--|				barwidth = width of the bar to be animated									|--
--|				barheight = height of the bar to be animated								|--
--|				direction = "left" or "right"												|--
--|				smoothdegree = degree to which the smooth slide effect occurs (default 3)	|--
--|				toonID = corresponds to the suiData.unit[N] (fewer calls if simply passed)	|--
-----------------------------------------------------------------------------------------------
function Sui_Animation(toon, kind, texture, barwidth, barheight, direction, smoothdegree, toonID)
	if toonID>10 and toonID~=8 then return end
	if kind=="Power" then
		local power
		if UnitPowerType(toon)==0 then
   			power = "Mana"
   		elseif UnitPowerType(toon)==1 then
   			power = "Rage"
   		elseif UnitPowerType(toon)==2 then
   			power = "Focus"
   		elseif UnitPowerType(toon)==3 then
   			power = "Energy"
   		end
   		texture = _G[texture.."_"..power.."Bar"]
   	elseif kind=="Cast" then
   		local gameTime = GameTime(toon)
   		if not gameTime then
				return
			end
   		if not suiData.unit[toonID].spellEnd then
				return
			end
		local castPercent = 100 - ((suiData.unit[toonID].spellEnd - gameTime) / suiData.unit[toonID].spellDuration) * 100
		if (castPercent > 100) then
			castPercent = 100
			suiData.unit[toonID].isCasting=0
			suiData.unit[toonID].isChanneling=0
		end
		suiData.unit[toonID].CastPercent = castPercent
		local castPoint = suiData.unit[toonID].spellEnd - gameTime		-- Time since cast started
		--local castPrint = (math.floor((castPoint*10)+0.5)) / 10  				-- the less detailed location for onscreen print
		local castPrint = (math.floor((castPoint*1000)+0.5)) / 1000 				-- the highly detailed location of the cast
		local relativeLag = (SUI_lag/1000) / (suiData.unit[toonID].spellDuration)
		if not suiData.unit[toonID].frame then return end
		_G[suiData.unit[toonID].frame.."_CastTime"]:SetText(string.format("%.1f", castPrint))
		texture = _G[texture]
		if suiData.unit[toonID].isCasting==0 and suiData.unit[toonID].isChanneling==0 then
			suiData.unit[toonID][kind.."progress"] = 0
			suiData.unit[toonID][kind.."Percent"] = 0
			_G[suiData.unit[toonID].frame .. "_CastText"]:Hide()
			_G[suiData.unit[toonID].frame .. "_CastTime"]:Hide()
			_G[suiData.unit[toonID].frame .. "_CastLatency"]:Hide()
			_G[suiData.unit[toonID].frame .. "_CastBar_Latency"]:Hide()
			texture:Hide()
		end
	else
   		texture = _G[texture]
   	end
	local fc1 = texture.frameCount or 1
	local fc2 = 40 + 1
	local frameCount = fc1 - (math.floor(fc1/fc2))
	local fr1 = frameCount - 1
	local fr2 = 16
	local frameRow = fr1 - (math.floor(fr1/fr2)) + 1
	texture.frameCount = frameCount
	if frameCount == 1 then
		texture.ColumnCount = 1
	elseif frameCount == 17 then
		texture.ColumnCount = 2
	elseif frameCount == 33 then
		texture.ColumnCount = 3
	end
	if texture.barheight and not texture.dimensionsLoaded then
		texture:SetHeight(texture.barheight)
		texture:SetWidth(texture.barwidth)
		texture.dimensionsLoaded = true
	end
	if not suiData.unit[toonID][kind.."progress"] then -- This variable is the stored value percent of a bars progress (1 - 100)
		suiData.unit[toonID][kind.."progress"] = 0
	elseif not string.find(suiData.unit[toonID][kind.."progress"], "%d+") then
		suiData.unit[toonID][kind.."progress"] = 0
	end
	local barProgress = suiData.unit[toonID][kind.."progress"]
	local barPercent = suiData.unit[toonID][kind.."Percent"]
	local FrameWidth = 0.3125 		-- Which is (1/512) * 160
	local FrameHeight = 0.0625		-- Which is (1/512) * 32
	local deficit = 0
	-- Fault protection
	if not barPercent then
		barPercent=0
	end
	-- Deghosting health/power bars on dead victims
	if barPercent==0 and barProgress>barPercent and kind~="Cast" then
		barProgress = 0
	end
	if suiData.lastTarget~=UnitGUID(toon) and suiData.lastTarget_checked==0 then
		barProgress = barPercent
		suiData.lastTarget_checked = 1
	end
	-- Target tapping/tagging
	if (UnitIsTapped("target")) and (not UnitIsTappedByPlayer("target")) then
		local shaderSupported = SUI_Target_HealthBar:SetDesaturated(1)
		if ( not shaderSupported ) then
			SUI_Target_HealthBar:SetVertexColor(0.5, 0.5, 0.5)
		end
	elseif not (UnitIsTapped("target")) then
		SUI_Target_HealthBar:SetDesaturated(nil)
		SUI_Target_HealthBar:SetVertexColor(1, 1, 1)
	end
	-- Based on kind (power or health) takes the percentage and adds to deficit
	-- a fraction of the current until it is close enough.  This basicly animates
	-- the bar making it slide smoothly as changes occur.
	if barProgress + 0.01 > barPercent and barProgress - 0.01 < barPercent then
		barProgress = barPercent
	else
		barProgress = barProgress + ((barPercent - barProgress)/smoothdegree)
	end
	deficit = FrameWidth * (barProgress * .01)
	if direction=="left" then
		local ULx = (FrameWidth * texture.ColumnCount) - FrameWidth
		local ULy = (FrameHeight * frameRow) - FrameHeight
		local LLx = (FrameWidth * texture.ColumnCount) - FrameWidth
		local LLy = (FrameHeight * frameRow)
		local URx = (FrameWidth * texture.ColumnCount) - (FrameWidth - deficit)
		local URy = (FrameHeight * frameRow) - FrameHeight
		local LRx = (FrameWidth * texture.ColumnCount) - (FrameWidth - deficit)
		local LRy = (FrameHeight * frameRow)
		texture:SetTexCoordModifiesRect(true)
		texture:SetTexCoord(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
	elseif direction=="right"  then
		local ULx = (FrameWidth * texture.ColumnCount) - (FrameWidth - deficit)
		local ULy = (FrameHeight * frameRow) - FrameHeight
		local LLx = (FrameWidth * texture.ColumnCount) - (FrameWidth - deficit)
		local LLy = (FrameHeight * frameRow)
		local URx = (FrameWidth * texture.ColumnCount - FrameWidth)
		local URy = (FrameHeight * frameRow) - FrameHeight
		local LRx = (FrameWidth * texture.ColumnCount - FrameWidth)
		local LRy = (FrameHeight * frameRow)
		texture:SetTexCoordModifiesRect(true)
		texture:SetTexCoord(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
	end
	--  Translate the xOffset to compensate for bottomleft origin
	local point, relativeTo, relativePoint, xOfs, yOfs = texture:GetPoint()
	if direction == "right" then
		direction = (barwidth/160 * 512) -496
	else
		direction = (barwidth - (barwidth/160 * 512) * deficit)
	end
	texture:SetPoint(point, relativeTo, relativePoint, direction, yOfs)

	-- Pass off globals
	suiData.unit[toonID][kind.."progress"] = barProgress
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Improves over the default crop function.  Normally called from the XML		|--
--|  Arguments:	texture = texture to crop													|--
--|  			top = top side of texture													|--
--|				right = right side of texture												|--
--|				bottom = bottom side of texture												|--
--|				left = left side of texture													|--
--|				modify = whether the crop transforms the texture dimensions or not			|--
--|				offset = compensates for cropping (since origin is bottomleft)				|--
-----------------------------------------------------------------------------------------------
function Sui_Crop(texture, top, right, bottom, left, modify, offset)
	local ULx = left
	local ULy = top
	local LLx = left
	local LLy = bottom
	local URx = right
	local URy = top
	local LRx = right
	local LRy = bottom
	texture:SetTexCoordModifiesRect(modify)
	texture:SetTexCoord(ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
	texture:SetHeight(texture:GetHeight() / (bottom-top)) -- fix cropping bug
	if offset then
		local point, relativeTo, relativePoint, xOfs, yOfs = texture:GetPoint()
		texture:SetPoint(point, relativeTo, relativePoint, xOfs+(texture:GetWidth()-(texture:GetWidth()*(right-left))), yOfs)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Hides or shows the expanded experience info window							|--
--|  Arguments:	toggle = "show", "hide"														|--
-----------------------------------------------------------------------------------------------
function Sui_XP_TooltipVisibility(toggle)
	if toggle == "show" then
		SetPortraitTexture(SUI_XP_Portrait, "player")
		SUI_XP_Portrait:Show()
		SUI_XP_Tooltip:Show()
	elseif toggle == "hide" then
		SUI_XP_Tooltip:Hide()
		SUI_XP_Portrait:Hide()
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Updates the XP Bar.															|--
-----------------------------------------------------------------------------------------------
function Sui_XPBar()
	local currentTime, totalTime
	if suiData.currentTime then
		currentTime = suiData.currentTime
		totalTime = suiData.totalTime
	end
	local currentXP, maxXP, restedXP = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion()
	if restedXP==nil then
		restedXP = 0
	elseif (restedXP + currentXP) > maxXP then
		restedXP = maxXP - currentXP
	end
	if currentXP==0 then
		currentXP = 0.1
	end
	UIFrameFlash(SUI_XPBarRestedHigh, 0.75, 1.25, -1, true, 0, 0)
	SUI_XPBar:SetWidth((currentXP/maxXP) * 402)
	SUI_XPBarRestedLow:SetWidth(((restedXP+currentXP)/maxXP) * 409)
	SUI_XPBarRestedHigh:SetWidth(((restedXP+currentXP)/maxXP) * 409)
	SUI_XP_CurrentXP:SetText("Experience(XP): "..currentXP.."/"..maxXP.."("..math.floor(((currentXP/maxXP)*100)+0.5).."%)")
	SUI_XP_CurrentRested:SetText("Rested XP: "..restedXP.."("..math.floor(((restedXP/maxXP)*100)+0.5).."%)")
	if type(currentTime)=="number" then
		local sessionTime = GetTime() - suiData.sessionMarker
		local timeSession = (maxXP-currentXP)/(suiData.sessionXP/sessionTime)
		local timeLevel = (maxXP-currentXP)/(currentXP/currentTime)
		if timeSession < timeLevel then
			estimateTime = timeSession
		else
			estimateTime = timeLevel
		end
		local estimateTime = SecondsToTime(estimateTime)
		SUI_XP_EstimatedTime:SetText("Time to level: "..estimateTime)
	end
	if SUI_mobXP then
		SUI_XP_EstimatedMobs:SetText("Mobs to level: "..math.floor(((maxXP-currentXP)/SUI_mobXP) + 0.5).." "..(SUI_mobLast or "Quests"))
	end
	suiData.FrameAdvance = 0
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Early animation method (needs to be replaced).  Flashes the frontend of the	|--
--| 			XP bar so its more visually interesting and noticeable.					|--
-----------------------------------------------------------------------------------------------
function Sui_XPIncrease()
	if suiData.FrameAdvance==1 then
		SUI_XP_Increase:SetTexCoord( 0, .25, 0, 1)
	elseif suiData.FrameAdvance== 2 then
		SUI_XP_Increase:SetTexCoord( .25, .50, 0, 1)
	elseif suiData.FrameAdvance== 3 then
		SUI_XP_Increase:SetTexCoord( .50, .75, 0, 1)
	elseif suiData.FrameAdvance== 4 then
		SUI_XP_Increase:SetTexCoord( .75, 1, 0, 1)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Hides or shows the expanded Reputation info window							|--
--|  Arguments:	toggle = "show", "hide"														|--
-----------------------------------------------------------------------------------------------
function Sui_Rep_TooltipVisibility(toggle)
	if toggle=="show" then
		local description
		suiData.factionIndex, description = Sui_FindFactionIndex()
		if description then
			SUI_Rep_Tooltip_Description:SetText(description or " ")
			SUI_Rep_Tooltip:Show()
		else
			SUI_Rep_Tooltip:Hide()
		end
	elseif toggle=="hide" then
		SUI_Rep_Tooltip:Hide()
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	This function might be the cause of some crashes (needs testing)			|--
--|  			Searches for which faction is currently being watched.						|--
-----------------------------------------------------------------------------------------------
function Sui_FindFactionIndex()
	if GetWatchedFactionInfo() then
		local factionIndex = 1
		while factionIndex do
			local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, isWatched = GetFactionInfo(factionIndex)
			if name then
				if not isWatched then
					factionIndex = factionIndex + 1
				else
					factionIndex = nil
					return factionIndex, description
				end
			elseif factionIndex > 500 then -- Failsafe
				factionIndex=nil
			else
				factionIndex=nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Updates the reputation bar (might be the cause of crashes)					|--
-----------------------------------------------------------------------------------------------
function Sui_RepBar()
	local RepName, RepReaction, minRep, maxRep, currentRep = GetWatchedFactionInfo()
	if RepName then
		SUI_RepBar:Show()
		SUI_RepBarLow:Show()
		SUI_RepBarLow2:Show()
		SUI_RepBar_Lead:Show()
		SUI_RepBar_LeadLow:Show()
		SUI_RepBar_LeadLow2:Show()
		if minRep < 0 then
			maxRep = maxRep * (-1)
			minRep = minRep * (-1)
			currentRep = currentRep * (-1)
		end
		if maxRep < minRep or maxRep==0 then
			local tempvar = maxRep
			maxRep = minRep
			minRep = tempvar
		end
		local Reputation = (currentRep - minRep)/(maxRep - minRep) * 402
		if Reputation==0 then
			Reputation = 0.1
		end
		if Reputation < 0 then
			Reputation = Reputation * (-1)
		end
		if not string.find(Reputation, "%d+") then
			Reputation = 1
		end
		if Reputation > 402 then
			Reputation = 402
		end
		SUI_RepBar:SetWidth(Reputation)
		SUI_RepBarLow:SetWidth(Reputation)
		SUI_RepBarLow2:SetWidth(Reputation)
		SUI_RepBar:SetVertexColor(0, 1, 0)
		SUI_RepBarLow:SetVertexColor(0, 1, 0)
		SUI_RepBarLow2:SetVertexColor(0, 1, 0)
		SUI_RepBarLow2:SetAlpha(0.5)
		SUI_RepBar_Lead:SetVertexColor(0, 1, 0)
		SUI_RepBar_LeadLow:SetVertexColor(0, 1, 0)
		SUI_RepBar_LeadLow2:SetVertexColor(0, 1, 0)
		local repTitle = "unknown"
		local unknown = "|c00808080 |r"
		local hated = "|c008c0000Hated|r"
		local hostile = "|c00ff0000Hostile|r"
		local unfriendly = "|c00ff8c00Unfriendly|r"
		local nuetral = "|c00bfbfbfNeutral|r"
		local friendly = "|c00ffffffFriendly|r"
		local honored = "|c0000ff00Honored|r"
		local revered = "|c004066e5Revered|r"
		local exalted = "|c009933ccExalted|r"
		if RepReaction==0 then
			repTitle=unknown
		elseif RepReaction==1 then
			repTitle=hated
		elseif RepReaction==2 then
			repTitle=hostile
		elseif RepReaction==3 then
			repTitle=unfriendly
		elseif RepReaction==4 then
			repTitle=nuetral
		elseif RepReaction==5 then
			repTitle=friendly
		elseif RepReaction==6 then
			repTitle=honored
		elseif RepReaction==7 then
			repTitle=revered
		elseif RepReaction==8 then
			repTitle=exalted
		end
		local relCur = currentRep-minRep
		local relMax = maxRep-minRep
		local relPer = math.floor((relCur/relMax)*100)
		if relCur==0 and relMax==0 then
			relPer = 0
		end
		SUI_Rep_Tooltip_Faction:SetText(RepName or "No Faction")
		SUI_Rep_Tooltip_Standing:SetText(repTitle)
		SUI_Rep_Tooltip_Count:SetText(relCur.."/"..relMax.." ("..relPer.."\%)")
	else
		SUI_RepBar:Hide()
		SUI_RepBarLow:Hide()
		SUI_RepBarLow2:Hide()
		SUI_RepBar_Lead:Hide()
		SUI_RepBar_LeadLow:Hide()
		SUI_RepBar_LeadLow2:Hide()
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Handles unit frames.  Two modes: setup or update.							|--
--|				Under "setup", will	fetch/show all unit info for the first load of unit.	|--
--|				Under "update", will update the current health/power levels.				|--
--|  Arguments:	toon (string) = UnitID of the frame to work with.							|--
--|				task = "setup", "update"													|--
-----------------------------------------------------------------------------------------------
function Sui_SetupMembers(toon,task)
	local toonID, frame, color
	if toon=="all" then
		for v = 1, 10, 1 do
			if v~=8 then
				toonID = Sui_DeriveUnit(v, "string")
				if not toonID then
					return
				end
				frame = suiData.unit[v].frame
				color = GetDifficultyColor(UnitLevel(toonID))
				Sui_SetupMembers_Subtask(toonID, task, v, frame, color)
			end
		end
	else
		local toonID = Sui_DeriveUnit(toon, "number", 10)
		if not toonID then
			return
		end
		frame = suiData.unit[toonID].frame
		color = GetDifficultyColor(UnitLevel(toon))
		Sui_SetupMembers_Subtask(toon, task, toonID, frame, color)
	end
end

function Sui_SetupMembers_Subtask(toon, task, toonID, frame, color, englishClass)
	if task=="setup" then
		if UnitExists(toon) and toonID<=10 then
			if toon=="target" then
				_G[frame.."Frame"]:Show()
				if UnitClassification("target")=="normal" then
					SUI_Target_EliteIcon:Hide()
				elseif UnitClassification("target")=="rare" or UnitClassification("target")=="rareelite" then
					SUI_Target_EliteIcon:SetTexture("Interface\\AddOns\\SpartanUI\\Textures\\Icon_Elite.blp")
					SUI_Target_EliteIcon:Show()
				elseif UnitClassification("target")=="worldboss" or UnitClassification("target")=="elite" then
					SUI_Target_EliteIcon:SetTexture("Interface\\AddOns\\SpartanUI\\Textures\\Icon_Elite.blp")
					SUI_Target_EliteIcon:Show()
				end
				Sui_GetSpec("target")
			elseif toon=="pet" then
				_G[frame]:Show()
				_, englishClass = UnitClass("player")
				if englishClass=="HUNTER" then
					SUI_Pet_HappinessIcon:Show()
				end
				if suiData.buffToggle == "on" then
					SUI_Self_Buffs:SetPoint("BOTTOMRIGHT", SUI_Self_Button, "TOPRIGHT", 40, 70)
				end
			elseif toon=="focus" then
				_G[frame]:Show()
				if suiData.buffToggle == "on" then
					SUI_Target_Buffs:SetPoint("BOTTOMLEFT", SUI_Target_Button, "TOPLEFT", -40, 70)
				end
			else
				if toonID>=3 and toonID<=6 then -- party members
					if (UnitInRaid("player") and suiData.PartyInRaid=="off") or suiData.partyToggle=="off" then
						_G[frame]:Hide()
					else
						_G[frame]:Show()
					end
				else
					_G[frame]:Show()
				end
			end
			if _G[frame.."_Name"]:GetText() == "Unknown" then
				Sui_DelayedCall("Sui_SetupMembers", toon..","..task, 1)
			end
			_G[frame.."_Name"]:SetText(UnitName(toon))
			_G[frame.."_Level"]:SetText(UnitLevel(toon))
			_G[frame.."_Level"]:SetTextColor(color.r, color.g, color.b)
			SetPortraitTexture(_G[frame.."_Portrait"], toon)
			Sui_RaidIcon()
			Sui_ClassIcon(toon, _G[frame.."_ClassIcon"])
			Sui_HealthMath(toon, suiData.unit[toonID].healthbar_width, suiData.unit[toonID].healthbar_height, frame)
			Sui_DelayedCall("Sui_Unit_UpdateAFK_Subtask", toon..","..toonID, 1)
			if suiData.buffToggle == "on" then
				Sui_BuffScan(toon)
			end
			if toon~="focus" then
				Sui_PowerMath(toon, suiData.unit[toonID].powerbar_width, suiData.unit[toonID].powerbar_height, frame)
			end
		elseif toon~="player" and toon~="target" then
			_G[frame]:Hide()
			-- Reset location of buffs
			if toon=="pet" and suiData.buffToggle == "on" then
				SUI_Self_Buffs:SetPoint("BOTTOMRIGHT", SUI_Self_Button, "TOPRIGHT", 15, 20)
			elseif toon=="focus" and suiData.buffToggle == "on" then
				SUI_Target_Buffs:SetPoint("BOTTOMLEFT", SUI_Target_Button, "TOPLEFT", -15, 20)
			end
		elseif toon=="target" then
			_G[frame.."Frame"]:Hide()
		end
	elseif task=="update" and toonID<=10 then
		Sui_HealthMath(toon, suiData.unit[toonID].healthbar_width, suiData.unit[toonID].healthbar_height, frame)
		if toon~="focus" then
			Sui_PowerMath(toon, suiData.unit[toonID].powerbar_width, suiData.unit[toonID].powerbar_height, frame)
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Hides/Shows party as designated by preferences.								|--
-----------------------------------------------------------------------------------------------
function Sui_UpdatePartyVisibility()
	local enable
	if UnitInRaid("player") then
		enable = suiData.PartyInRaid
	else
		enable = suiData.partyToggle
	end
	for i = 1,4 do
		if (enable == "on") and ( UnitExists("party"..i) ) then
			_G["SUI_Party"..i.."Frame"]:Show()
			_G["SUI_Party"..i]:Show()
		else
			_G["SUI_Party"..i.."Frame"]:Hide()
			_G["SUI_Party"..i]:Hide()
		end
	end
	if suiData.buffToggle == "on" then
		Sui_BuffScan(arg1)
	end
	PartyMemberFrame1:UnregisterAllEvents()
	PartyMemberFrame1:Hide()
	PartyMemberFrame2:UnregisterAllEvents()
	PartyMemberFrame2:Hide()
	PartyMemberFrame3:UnregisterAllEvents()
	PartyMemberFrame3:Hide()
	PartyMemberFrame4:UnregisterAllEvents()
	PartyMemberFrame4:Hide()
	PartyMemberBackground:SetAlpha(0)
	PartyMemberBackground:Hide()
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Control function for remote inspection.										|--
-----------------------------------------------------------------------------------------------
function Sui_GetSpec(toon, inspected)
	if not inspected then
		if UnitExists("target") then
			SUI_MouseTooltip_Text:SetText("Not available.")
			if CheckInteractDistance("target", 1)==1 and not UnitIsUnit("target", "player") then
				NotifyInspect("target")
			elseif UnitIsUnit("target", "player") then
				Sui_DeliverSpecInfo((Sui_FindSpecInfo("player")))
			else
				local englishFaction1, localizedFaction = UnitFactionGroup("target")
				local englishFaction2, localizedFaction = UnitFactionGroup("player")
				local _, instanceType = IsInInstance()
				local isPlayer, sameFaction, notPVP = UnitIsPlayer("target"), englishFaction1==englishFaction2, instanceType~="pvp"
				if isPlayer==1 and sameFaction==true and notPVP==true then
					SendAddonMessage("SUI", "find "..UnitName("player").." spec".." ".."current", "WHISPER", UnitName("target"))
				end
			end
		end
	elseif inspected then
		local value = Sui_FindSpecInfo("target")
		if value then
			Sui_DeliverSpecInfo(value)
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Fetches unit info for remote inspection.									|--
-----------------------------------------------------------------------------------------------
function Sui_FindSpecInfo(toon, caller)
	if toon=="target" then
		inspect = 1
	else
		inspect = false
	end
	local t1Name, t1IconTexture, t1 = GetTalentTabInfo(1, inspect)
	local t2Name, t2IconTexture, t2 = GetTalentTabInfo(2, inspect)
	local t3Name, t3IconTexture, t3 = GetTalentTabInfo(3, inspect)
	local localizedClass, englishClass = UnitClass(toon)
	local content
	if not t3IconTexture then
		content="Not available"
	else
		content = (t1.."|"..t2.."|"..t3.."|"..(englishClass or "Unknown").."|"..t1IconTexture.."|"..t2IconTexture.."|"..t3IconTexture)
	end
	if caller then
		SendAddonMessage("SUI", "deliver "..toon.." spec "..content, "WHISPER", caller)
	else
		return content
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Fetches unit info for remote inspection.									|--
-----------------------------------------------------------------------------------------------
function Sui_DeliverSpecInfo(value)
	local t1, t2, t3, englishClass, t1IconTexture, t2IconTexture, t3IconTexture = strsplit("|", value)
	t1 = tonumber(t1)
	t2 = tonumber(t2)
	t3 = tonumber(t3)
	t1 = t1 or 0
	t2 = t2 or 0
	t3 = t3 or 0
	if ((t1 > t2) and (t1 > t3)) then
		spec = 2
	elseif (t2 > t3) then
		spec = 3
	else
		spec = 4
	end
	local text = "Not Available."
	if SUI_Lang[englishClass] then
		text = "|cffffc100"..(SUI_Lang[englishClass][spec] or "error").." "
		text = text..(SUI_Lang[englishClass][1] or "error").."|r\r\n\r\n|T"
		text = text..(t1IconTexture or "error")..":16:16:0:0|t "
		text = text..(SUI_Lang[englishClass][2] or "error")..": "
		text = text..(t1 or "error").."\r\n|T"
		text = text..(t2IconTexture or "error")..":16:16:0:0|t "
		text = text..(SUI_Lang[englishClass][3] or "error")..": "
		text = text..(t2 or "error").."\r\n|T"
		text = text..(t3IconTexture or "error")..":16:16:0:0|t "
		text = text..(SUI_Lang[englishClass][4] or "error")..": "
		text = text..(t3 or "error")
	end
	SUI_MouseTooltip_Text:SetText(text)
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Queries for presence of focus unit.											|--
-----------------------------------------------------------------------------------------------
function Sui_FocusUpdate()
	if UnitExists("focus") and not SUI_Focus:IsVisible() then
		Sui_SetupMembers("focus", "setup")
		-- DEFAULT_CHAT_FRAME:AddMessage("Unit exists.  Frame not visible.  Sending call...", 0.5, 0.5, 0.5)
		Sui_DelayedCall("Sui_FocusUpdate", _, 5)
	elseif UnitExists("focus") and SUI_Focus:IsVisible() then
		Sui_DelayedCall("Sui_FocusUpdate", _, 5)
		-- DEFAULT_CHAT_FRAME:AddMessage("Unit exists.  Frame visible.  Sending call...", 0.5, 0.5, 0.5)
	elseif not UnitExists("focus") then
		Sui_SetupMembers("focus", "setup")
		-- DEFAULT_CHAT_FRAME:AddMessage("Unit no longer present.  Hiding frame.", 0.5, 0.5, 0.5)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Sets icons on unit frames.													|--
-----------------------------------------------------------------------------------------------
function Sui_Unit_Update()
	if (UnitExists("player")) then
		Sui_Unit_UpdateLootMethod()
		Sui_Unit_UpdatePvPStatus()
	end
	Sui_Unit_UpdatePartyLeader()
	Sui_Unit_UpdateStatus()
	if  UnitExists("target") then
		SUI_Target:Show()
	else
		SUI_Target:Hide()
	end
	if (Adapt) then
		Adapt_Settings.Shape = "CIRCLE"
		Adapt.Reshape()
		Adapt_Settings.Backdrop = Adapt_Settings.Backdrop=="ON"
		Adapt.Reback()
	end
end
------------------------------------------------------------------------------------------------
--|  Purpose:	Derives the unit string based on number, or unit number based on string      |--
--|  Arguments:	toon = string or number of unit to reverse									 |--
--|				desiredType (string) = whether the results should be a string or number.	 |--
--|				limit (number) = max number of units to compare.							 |--
------------------------------------------------------------------------------------------------
function Sui_DeriveUnit(toon, desiredType, limit)
	local i, toonID = 1
	local varType = type(toon)
	if varType == "string" then
		local start, finish = string.find(toon, "raid", 1, true)
		if start then
			for v = 1, 40, 1 do
				while i and i<=(limit or 10) do
					if UnitIsUnit(toon, suiData.unit[i].unit) then
						toonID, varType = i, "number"
						i = nil
					else
						i = i + 1
					end
				end
			end
		else
			while suiData.unit[i] and i<=(limit or #suiData.unit) do
				if toon==suiData.unit[i].unit then
					toonID, varType = i, "number"
					i = nil
				else
					i = i + 1
				end
			end
		end
	elseif varType == "number" then
		while suiData.unit[i] and i<=(limit or #suiData.unit) do
			if toon==i then
				toonID, varType = suiData.unit[i].unit, type(suiData.unit[i].unit)
				i = nil
			else
				i = i + 1
			end
		end
	else
		toonID = "invalid"
	end
	if toonID and varType==desiredType then
		if desiredType=="number" and suiData.unit[toonID] and suiData.unit[toonID].frame then
			return toonID
		elseif desiredType=="string" and toonID~="invalid" then
			return toonID
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Updates the number of charges shown											|--
-----------------------------------------------------------------------------------------------
function Sui_UpdateComboPoints()
	local points = GetComboPoints()
	local _, englishClass = UnitClass("player")
	if englishClass~="WARRIOR" then
		ComboFrame:SetAlpha(0)
		ComboFrame:Hide()
		if points==0 then
			SUI_Target_Combo1:Hide()
			SUI_Target_Combo2:Hide()
			SUI_Target_Combo3:Hide()
			SUI_Target_Combo4:Hide()
			SUI_Target_Combo5:Hide()
		elseif points==1 then
			SUI_Target_Combo1:Show()
			SUI_Target_Combo2:Hide()
			SUI_Target_Combo3:Hide()
			SUI_Target_Combo4:Hide()
			SUI_Target_Combo5:Hide()
		elseif points==2 then
			SUI_Target_Combo1:Show()
			SUI_Target_Combo2:Show()
			SUI_Target_Combo3:Hide()
			SUI_Target_Combo4:Hide()
			SUI_Target_Combo5:Hide()
		elseif points==3 then
			SUI_Target_Combo1:Show()
			SUI_Target_Combo2:Show()
			SUI_Target_Combo3:Show()
			SUI_Target_Combo4:Hide()
			SUI_Target_Combo5:Hide()
		elseif points==4 then
			SUI_Target_Combo1:Show()
			SUI_Target_Combo2:Show()
			SUI_Target_Combo3:Show()
			SUI_Target_Combo4:Show()
			SUI_Target_Combo5:Hide()
		elseif points==5 then
			SUI_Target_Combo1:Show()
			SUI_Target_Combo2:Show()
			SUI_Target_Combo3:Show()
			SUI_Target_Combo4:Show()
			SUI_Target_Combo5:Show()
		end
	end
end
------------------------------------------------------------------------------------------------
--|  Purpose:	Creates all buff frames for population based on suiData.unit[i].frame        |--
--|  Variables:	subject = "Buff", "Debuff" or "Weapon"										 |--
--|				i = current unit (1-8)														 |--
--|				ii = current buff (as many as there are)									 |--
--|				frame = from suiData.unit[i].frame, the name of the unit frame.				 |--
------------------------------------------------------------------------------------------------
function Sui_BuffCreateFrames()
	local i = 1
	while suiData.unit[i] and i<=10 do
		local state = "HELPFUL"
		local ii = 1
		while ii do
			-- Initialize variables
			local subject
			if state == "HELPFUL" then
				subject = "Buff"
			elseif state == "HARMFUL" then
				subject = "Debuff"
			elseif state == "WEAPON" then
				subject = "Weapon"
			end
			local direction = suiData.unit[i].direction
			local runDirection = suiData.unit[i].runDirection
			local father_string = suiData.unit[i].frame .. "_" .. subject .. "_" .. ii
			local master_string = suiData.unit[i].frame .. "_" .. subject .. "s"
			local icon, count, master, bar, timer
			local buffSize = suiData.unit[i].buffSize
			local scaleFactor = 1
			local buffPadding = suiData.unit[i].buffPadding
			-- Create parent frame
			if not _G[master_string] then
				-- Buff Placement
				local selfAnchor, parentAnchor, parentAnchorDebuff, xOffset, yOffset
				if direction=="left" then
					if suiData.unit[i].unit ~= "player" then
						-- Party Buffs
						selfAnchor = "TOPLEFT"
						parentAnchor = "TOPLEFT"
						parentAnchorDebuff = "TOPRIGHT"
						xOffset = 30
						yOffset = 2
					else
						-- Self Buffs
						selfAnchor = "BOTTOMRIGHT"
						parentAnchor = "TOPRIGHT"
						xOffset = 15
						yOffset = 20
					end
				elseif direction=="right" then
					if suiData.unit[i].unit ~= "target" then
						-- Target of Targets Buffs
						selfAnchor = "TOPRIGHT"
						parentAnchor = "TOPRIGHT"
						parentAnchorDebuff = "TOPLEFT"
						xOffset = -30
						yOffset = 2
					else
						-- Target Buffs
						selfAnchor = "BOTTOMLEFT"
						parentAnchor = "TOPLEFT"
						xOffset = -15
						yOffset = 20
					end
				end
				master = CreateFrame("Frame", master_string, _G[suiData.unit[i].frame .. "Frame_Info"])
				master:SetWidth(buffSize)
				master:SetHeight(buffSize)
				master.bgTexture = master:CreateTexture(master_string.."_BuffBG")
				master.bgTexture:SetTexture("Interface\\AddOns\\SpartanUI\\Textures\\Object_Buff_BG.blp")
				master.direction = suiData.unit[i].direction
				master.bgTexture:SetParent(master)
				master.bgTexture:SetAlpha(.55)
				master:SetPoint(selfAnchor, _G[suiData.unit[i].frame .. "_Button"], parentAnchor, xOffset, yOffset)
				if subject=="Debuff" then
					local debuffParent, multiplier = _G[suiData.unit[i].frame .. "_" .. "Buffs"], 1
					xOffset, yOffset = 0, (6 + buffPadding)
					if direction~=runDirection then
						parentAnchor = parentAnchorDebuff
						debuffParent = _G[suiData.unit[i].frame .. "_" .. "Buff_" .. suiData.unit[i].buffLimit]
						if runDirection=="left" then
							multiplier = -1
						end
						xOffset, yOffset = (1 * multiplier), 7
					end
					master:SetPoint(selfAnchor, debuffParent, parentAnchor, xOffset, yOffset)
				elseif subject=="Weapon" then
					master:SetPoint(selfAnchor, _G[suiData.unit[i].frame .. "_" .. "Debuffs"], parentAnchor, 0, (6 + buffPadding))
				end
				master:SetParent(_G[suiData.unit[i].frame .. "Frame_Info"])
			else
				master = _G[master_string]
			end
			-- Create buff button
			local father = CreateFrame("Button", father_string, master)
			-- Anchor and position child buffs to parent frame
			-- If prior buff-button exists, anchor to it instead
			if _G[suiData.unit[i].frame .. "_Buff_" .. (ii-1)] then
				if runDirection=="left" then
					father:SetPoint("BOTTOMRIGHT", _G[suiData.unit[i].frame .. "_".. subject .. "_" .. (ii-1)], "BOTTOMLEFT", -2, 0)
				elseif runDirection=="right" then
					father:SetPoint("BOTTOMLEFT", _G[suiData.unit[i].frame .. "_" .. subject .. "_" .. (ii-1)], "BOTTOMRIGHT", 2, 0)
				end
			else
				if runDirection=="left" then
					father:SetPoint("BOTTOMRIGHT", master, "BOTTOMRIGHT", -1, -7)
				elseif runDirection=="right" then
					father:SetPoint("BOTTOMLEFT", master, "BOTTOMLEFT", 1, -7)
				end
			end
			father:SetWidth(buffSize)
			father:SetHeight(buffSize)
			father:SetScript("OnEnter", Sui_BuffTooltip_Enter)
			father:SetScript("OnLeave", Sui_BuffTooltip_Leave)
			father:SetScript("OnClick", Sui_BuffTooltip_Click)
			father:RegisterForClicks("RightButtonDown")
			father:EnableMouse(true)
			icon = father:CreateTexture((father_string .. "_Icon"),"HIGH")
			icon:SetTexCoord(0.078125,0.921875,0.078125,0.921875)
			icon:SetAllPoints(father)
			icon.buffSize = buffSize
			count = father:CreateFontString(father_string .. "_Count","OVERLAY")
			count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 0)
			count:SetFontObject(SUI_FontMicro)
			count:SetJustifyH("CENTER")
			count:SetParent(father)
			father:SetScale(scaleFactor)
			ii = ii + 1
			if state=="HELPFUL" and ii > suiData.unit[i].buffLimit then
				state = "HARMFUL"
				ii = 1
			elseif state=="HARMFUL" and ii > suiData.unit[i].debuffLimit and suiData.unit[i].unit=="player" then
				state = "WEAPON"
				ii = 1
			elseif state=="HARMFUL" and ii > suiData.unit[i].debuffLimit then
				ii = nil
			elseif state=="WEAPON" and ii > suiData.unit[i].weaponLimit then
				ii = nil
			end
		end
		i = i + 1
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Scans the unit for buffs and debuffs, then adds it to a database			|--
--|  Arguments:	toon = "player", "party1", etc...											|--
-----------------------------------------------------------------------------------------------
function Sui_BuffScan(toon)
	-- Scan for buffs/debuffs
	if toon=="player" then
		-- initialize variables
		local helpful = {}
		local harmful = {}
		local i = 1
		local state, indexNum, untilCancelled, applications, buffName, buffTexture, buffTime, buffTimeMarker, tempDB = "PASSIVE"
		while i do
			-- restart values
			indexNum, untilCancelled, applications, buffName, buffTexture, buffTime, buffTimeMarker, tempDB = nil, nil, nil, nil, nil, nil, nil, nil
			-- Scan for buff at location i
			indexNum, untilCancelled = GetPlayerBuff(i, state)
			applications = GetPlayerBuffApplications(indexNum)
			buffName = GetPlayerBuffName(indexNum)
			buffTexture = GetPlayerBuffTexture(indexNum)
			buffTime = GetPlayerBuffTimeLeft(indexNum)
			buffTimeMarker = GetTime()

			-- Tests for valid buff.  If it fails, it moves to the next state or kills the cycle.
			-- Alternatively, if found, records the buff and iterates to the next buff.
			if not buffTexture then
				if state=="PASSIVE" then
					state = "HELPFUL"
					i = 1
				elseif state=="HELPFUL" then
					state = "HARMFUL"
					i = 1
				elseif state=="HARMFUL" then
					i = nil
				end
			else
				-- Record the results
				tempDB = {
					["type"] = state,
					["buffName"] = buffname,
					["index"] = indexNum,
					["buffTime"] = buffTime,
					["applications"] = applications,
					["buffTexture"] = buffTexture,
					["buffTimeMarker"] = buffTimeMarker,
				}
				-- Record results to parent table
				if state=="HELPFUL" or state=="PASSIVE" then
					if not helpful[i] then	-- If a buff was passive, will retain that type
						helpful[i] = tempDB
					end
				elseif state=="HARMFUL" then
					harmful[i] = tempDB
				end
				-- iterate
				i = i + 1
			end
		end
		-- Weapon enchantments
		local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
		local offHandTexture, mainHandTexture
		local weapons = {}
		if hasMainHandEnchant then
			mainHandTexture = GetInventoryItemTexture("player", 16)
			weapons[1] = {
				["type"] = "Weapon",
				["buffName"] = "Enchant 1",
				["index"] = 16,
				["buffTime"] = mainHandExpiration,
				["applications"] = mainHandCharges,
				["buffTexture"] = mainHandTexture,
				["buffTimeMarker"] = GetTime(),
			}
		end
		if hasOffHandEnchant then
			offHandTexture = GetInventoryItemTexture("player", 17)
			weapons[2] = {
				["type"] = "Weapon",
				["buffName"] = "Enchant 2",
				["index"] = 17,
				["buffTime"] = offHandExpiration,
				["applications"] = offHandCharges,
				["buffTexture"] = offHandTexture,
				["buffTimeMarker"] = GetTime(),
			}
		end
		-- Dissemination
		suiData.unit[1].Buff, suiData.unit[1].Debuff, suiData.unit[1].Weapon = nil, nil, nil
		suiData.unit[1].Buff = helpful
		suiData.unit[1].Debuff = harmful
		suiData.unit[1].Weapon = weapons
	else
		-- initialize variables
		local toonID = Sui_DeriveUnit(toon, "number", 10)
		if not toonID then return end
		local helpful = {}
		local harmful = {}
		local i = 1
		local state, buffName, rank, buffTexture, applications, debuffType, buffTime, castable, tempDB = "HELPFUL"
		while i and i<=40 and toonID<=10 do
			-- restart values
			buffName, rank, buffTexture, applications, debuffType, buffTime, castable = nil, nil, nil, nil, nil, nil, nil, nil
			-- Scan for buff at location i
			if state=="HELPFUL" then
				buffName, rank, buffTexture, applications, _, buffTime =  UnitBuff(toon, i)
			elseif state=="HARMFUL" then
				buffName, rank, buffTexture, applications, debuffType, _, buffTime  =  UnitDebuff(toon, i)
			end
			-- Tests for valid buff.  If it fails, it moves to the next state or kills the cycle.
			-- Alternatively, if found, records the buff and iterates to the next buff.
			if not buffTexture then
				if state=="HELPFUL" then
					state = "HARMFUL"
					i = 1
				elseif state=="HARMFUL" then
					i = nil
				end
			else
				-- Record the results
				tempDB = {
					["type"] = state,
					["buffName"] = buffname,
					["index"] = i,
					["buffTime"] = buffTime,
					["applications"] = applications,
					["buffTexture"] = buffTexture,
				}
				-- Record results to parent table
				if state=="HELPFUL" then
					helpful[i] = tempDB
				elseif state=="HARMFUL" then
					harmful[i] = tempDB
				end
				-- iterate
				i = i + 1
			end
		end
		suiData.unit[toonID].Buff, suiData.unit[toonID].Debuff  = nil, nil
		suiData.unit[toonID].Buff = helpful
		suiData.unit[toonID].Debuff = harmful
	end
	Sui_BuffPopulate(toon)
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Scans the list of current buffs for castability.							|--
--|  Note:		This function is temporarily abandoned.  Having poor success with it.		|--
-----------------------------------------------------------------------------------------------
function Sui_BuffGetCastable(toon, helpful)
	-- DEFAULT_CHAT_FRAME:AddMessage("Castability Fired.", 0.5, 0.5, 0.5)
	local i = 1
	while i do
		local x = 1
		local name =  UnitBuff(toon, i, 1)
		if name then
			while helpful[x] do
				if helpful[x].buffName == name then
					helpful[x].castable = "true"
				end
				x = x + 1
			end
			i = i + 1
		else
			i = nil
		end
	end
	return helpful
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Sorts buffs according to priorities set by the user.						|--
--|  Note:		Incomplete																	|--
-----------------------------------------------------------------------------------------------
function Sui_BuffSort(toon)
	local i = Sui_DeriveUnit(toon)
	local subject = "Buff"
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Poplulates a units buff frames with the appropriate text/icon/count from DB	|--
--|  Arguments:	toon = "player", "party1", etc...											|--
--|  Variables: i = curent unit (a.k.a. toon) found in suiData.unit[x].unit					|--
--|				ii = current buff/debuff being operated on									|--
--|				subject = "Buff" or "Debuff"												|--
--|				state = "HARMFUL", "HELPFUL", "WEAPON"										|--
-----------------------------------------------------------------------------------------------
function Sui_BuffPopulate(toon)
	local i = Sui_DeriveUnit(toon, "number", 10)
	if not i then return end
	if i<=10 and i~=8 then
		local ii = 1
		local state
		local subject
		while ii do
			if ii==1 and not state then
				subject = "Buff"
				state = "HELPFUL"
			elseif ii==1 and state=="HELPFUL" then
				subject = "Debuff"
				state = "HARMFUL"
			elseif ii==1 and state=="HARMFUL" and toon=="player" then
				subject = "Weapon"
				state = "WEAPON"
			end
			local father = _G[suiData.unit[i].frame .. "_" .. subject .. "_" .. ii]
			local icon = _G[suiData.unit[i].frame .. "_" .. subject .. "_" .. ii .. "_Icon"]
			local count = _G[suiData.unit[i].frame .. "_" .. subject .. "_" .. ii .. "_Count"]
			local currentBuff
			if suiData.unit[i][subject] then
				if suiData.unit[i][subject][ii] then
					father:Show()
					icon:SetTexture(suiData.unit[i][subject][ii].buffTexture)
					-- Fix for zeros and ones
					local counter
					if suiData.unit[i][subject][ii].applications == 0 or suiData.unit[i][subject][ii].applications == 1 then
						counter = nil
					else
						counter = suiData.unit[i][subject][ii].applications
					end
					count:SetText(counter)
					father.state = subject
					father.index = suiData.unit[i][subject][ii].index
					father.castable = suiData.unit[i][subject].castable
					father.direction = suiData.unit[i].direction
					father.toon = suiData.unit[i].unit
					currentBuff = true
				else
					currentBuff = false
				end
			end
			local nextBuff
			if suiData.unit[i][subject] then
				if suiData.unit[i][subject][ii + 1] then
					nextBuff = true
				else
					nextBuff = false
				end
			end
			-- iterate
			ii = ii + 1
			-- restart or kill cycle
			if toon=="player" then
				if state=="HELPFUL" and (nextBuff==false or ii > suiData.unit[i].buffLimit) then
					Sui_BuffCleanup(suiData.unit[i].frame .. "_" .. subject, ii, nextBuff, currentBuff, i)
					ii = 1
				elseif state=="HARMFUL" and (nextBuff==false or ii > suiData.unit[i].debuffLimit) then
					Sui_BuffCleanup(suiData.unit[i].frame .. "_" .. subject, ii, nextBuff, currentBuff, i)
					ii = 1
				elseif state=="WEAPON" and (nextBuff==false or ii > suiData.unit[i].weaponLimit) then
					Sui_BuffCleanup(suiData.unit[i].frame .. "_" .. subject, ii, nextBuff, currentBuff, i)
					ii = nil
				end
			else
				if state=="HELPFUL" and (nextBuff==false or ii > suiData.unit[i].buffLimit) then
					Sui_BuffCleanup(suiData.unit[i].frame .. "_" .. subject, ii, nextBuff, currentBuff, i)
					ii = 1
				elseif state=="HARMFUL" and (nextBuff==false or ii > suiData.unit[i].debuffLimit) then
					Sui_BuffCleanup(suiData.unit[i].frame .. "_" .. subject, ii, nextBuff, currentBuff, i)
					ii = nil
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Pushes updates to bar, timer, and gametooltips (all which rely on time)		|--
--|  Note:		Updates occur at 12.5 updates per second, sufficient for bar animation but	|--
--|				too fast for text updates.  Use of a global marker is implemented to slow	|--
-----------------------------------------------------------------------------------------------
function Sui_BuffUpdate()
	local subject = "Buff"
	local x = 1
	while x do
		-- recursive DB test for presence. Fault-protection
		if suiData.unit[1][subject] then
			if suiData.unit[1][subject][x] then
				if suiData.unit[1][subject][x].buffTime then
				-- end DB test
					local start = suiData.unit[1][subject][x].buffTime
					local current = (GetTime() - suiData.unit[1][subject][x].buffTimeMarker)
					local max = start - GetTime()
					local time = date("*t", (start - current))
					local timePrint
					-- SUI_TestString2:SetText(time.hour.. " | "..time.min.. " | "..time.sec)
					local bar = _G[suiData.unit[1].frame .. "_" .. subject .. "_" .. x .. "_Bar"]
					local timer = _G[suiData.unit[1].frame .. "_" .. subject .. "_" .. x .. "_Timer"]
					local buffSize = (_G[suiData.unit[1].frame .. "_" .. subject .. "_" .. x .. "_Icon"]).buffSize
					if current > start then
						current = start
					end
					if (time) then
						if (time.min > 0) then timePrint = time.min;
						else timePrint = time.sec; end
					end
					-- timer:SetText(timePrint)
					-- bar:SetWidth((1 - current/start) * buffSize)
					x = x + 1
				elseif subject=="Buff" then
					subject = "Debuff"
					x = 1
				elseif subject=="Debuff" then
					subject = "Weapon"
					x = 1
				elseif subject=="Weapon" then
					x = nil
				end
			else
				x = nil
			end
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Hides further buffs from showing and sets the size of the BG to fit buffs	|--
--|  Arguments:	frame (string) = e.g., "SUI_Self_Buff_"										|--
--|  			ii = current buff/debuff being operated on									|--
--|				next (boolean) = whether theres another buff after the current				|--
--|				current (boolean) = whether the current buff exists							|--
--|				i = curent unit (a.k.a. toon) found in suiData.unit.x						|--
-----------------------------------------------------------------------------------------------
function Sui_BuffCleanup(frame, ii, next, current, i)
	if current==false then
		ii = ii - 1
	elseif next==false then
		ii = ii
	end
	if _G[frame .. "s"] then
		if _G[frame .. "s"].bgTexture then
			local texture = _G[frame .. "s"].bgTexture
			local direction = _G[frame .. "s"].direction
			local firstBuff = _G[frame .. "_" .. 1]
			local lastBuff = _G[frame .. "_" .. ii-1]
			local padding = suiData.unit[i].buffPadding
			-- if there are no buffs/debuffs, hide the background
			if (ii-1) == 0 then
				texture:Hide()
			else
				texture:Show()
			end
			-- set the size of the background according to the first and last buffs with padding
			if direction=="left" then
				texture:SetPoint("BOTTOMRIGHT", firstBuff, "BOTTOMRIGHT", padding, -(padding))
				texture:SetPoint("TOPLEFT", lastBuff, "TOPLEFT", -padding, (padding))
			elseif direction=="right" then
				texture:SetPoint("BOTTOMLEFT", firstBuff, "BOTTOMLEFT", -padding, -(padding))
				texture:SetPoint("TOPRIGHT", lastBuff, "TOPRIGHT", padding, (padding))
			end
		end
	end
	while ii do
		local nextFrame = _G[frame .. "_" .. ii]
		if nextFrame then
			nextFrame:Hide()
			ii = ii + 1
		else
			ii = nil
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Searches under mouse for which buff frame youre over and shows the			|--
--|				appropriate buff info accordingly.											|--
-----------------------------------------------------------------------------------------------
function Sui_BuffTooltip_Enter()
	-- Produces the list of frames
	local frame = EnumerateFrames()
	-- if it finds a frame thats visible and under the mouse...
	while frame do
    	if frame:IsVisible() and MouseIsOver(frame) then
    		local frame_string = frame:GetName()
    		local start, finish
    		-- ...then scan it for our keyphrases
    	    if type(frame_string)=="string" then
	    		start, finish = string.find(frame_string, "_Buff_", 1, true)
	    		if not start then
	    			start, finish = string.find(frame_string, "_Debuff_", 1, true)
	    			if not start then
	    				start, finish = string.find(frame_string, "_Weapon_", 1, true)
	    			end
	    		end
    	    end
    	    -- if a match is found, setup tooltip and show
    	    if start then
    	    	local father = _G[frame_string]
    	    	local castable = father.castable
    	    	local index = father.index
    	    	local state = father.state
    	    	local direction = father.direction
    	    	local toon = father.toon
    		   -- DEFAULT_CHAT_FRAME:AddMessage("father: "..frame_string.." | index: "..index.." | state: "..state.." | direction: "..direction.." | toon: "..toon, 0.5, 0.5, 0.5)
    	    	GameTooltip:SetOwner(father, direction)
   				if toon=="player" then
					if state=="Weapon" then
						GameTooltip:SetInventoryItem("player", index)
					else
						GameTooltip:SetPlayerBuff(index)
					end
				else
					if state=="Buff" then
						GameTooltip:SetUnitBuff(toon, index)
					elseif state=="Debuff" then
						GameTooltip:SetUnitDebuff(toon, index)
					end
				end
    	    	GameTooltip:Show()
    	    	-- and toggle for repeat updates of tooltips
    	    	suiData.tooltipUpdate = true
    	    end
    	end
    	-- returns frame which follows current frame
    	frame = EnumerateFrames(frame)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Dev tool. Shows your inventory to chat.										|--
--|				/script RunThrough()														|--
-----------------------------------------------------------------------------------------------
function RunThrough()
	local index, itemName, ItemLink = 0
	while index < 24 do
		GameTooltip:SetInventoryItem("player", index)
		itemName, ItemLink = GameTooltip:GetItem()
		if itemName then
			DEFAULT_CHAT_FRAME:AddMessage(index..": ".. itemName..", "..ItemLink, .25, .25, 1)
		else
			DEFAULT_CHAT_FRAME:AddMessage(index..": empty", .5, 0, 0)
		end
		index = index + 1
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Hides the tooltip.															|--
-----------------------------------------------------------------------------------------------
function Sui_BuffTooltip_Leave()
	GameTooltip:Hide()
	suiData.tooltipUpdate = false
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Handles canceling the buff in question.										|--
-----------------------------------------------------------------------------------------------
function Sui_BuffTooltip_Click()
	local frame = EnumerateFrames()
	while frame do
    	if frame:IsVisible() and MouseIsOver(frame) then
    		local frame_string = frame:GetName()
    	    local start, finish = string.find(frame_string, "_Buff_", 1, true)
    	    if start then
    	    	local father = _G[frame_string]
    	    	if father.toon == "player" then
	    	    	CancelPlayerBuff(father.index)
	    	    end
    	    else
    	    	start, finish = string.find(frame_string, "_Weapon_", 1, true)
    	    	if start then
    	    		local father = _G[frame_string]
    	    		if father.index == 16 then
    	    			CancelItemTempEnchantment(1)
    	    		elseif father.index == 17 then
    	    			CancelItemTempEnchantment(1)
    	    		end
    	    	end
    	    end
    	end
    	frame = EnumerateFrames(frame)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Populates the units with buffs for testing purposes.						|--
-----------------------------------------------------------------------------------------------
function Sui_BuffConjure()
	DEFAULT_CHAT_FRAME:AddMessage(" ")
	local i, iB, iD, iW, tempDB, unitBuffs, unitDebuffs, unitWeapons, buffLimit, debuffLimit, weaponLimit = 1
	while suiData.unit[i] and i <= 10 do
		suiData.unit[i].Buff, suiData.unit[i].Debuff, suiData.unit[i].Weapon = {}, {}, {}
		buffLimit, debuffLimit, weaponLimit = suiData.unit[i].buffLimit, suiData.unit[i].debuffLimit, suiData.unit[i].weaponLimit
		iB, iD, iW = 1, 1, 1
		while iB <= buffLimit do
			tempDB = {
				["type"] = "HELPFUL",
				["index"] = iB,
				["buffTime"] = 1500,
				["applications"] = iB,
				["buffTimeMarker"] = GetTime(),
				["buffTexture"] = "Interface\\Icons\\Spell_Nature_NatureBlessing",
			}
			table.insert(suiData.unit[i].Buff, tempDB)
			iB = iB + 1
		end
		while iD <= debuffLimit do
			tempDB = {
				["type"] = "HARMFUL",
				["index"] = iD,
				["buffTime"] = 1500,
				["applications"] = iD,
				["buffTimeMarker"] = GetTime(),
				["buffTexture"] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
			}
			table.insert(suiData.unit[i].Debuff, tempDB)
			iD = iD + 1
		end
		if weaponLimit then
			while iW <= weaponLimit do
				tempDB = {
					["type"] = "WEAPON",
					["index"] = iW,
					["buffTime"] = 1500,
					["applications"] = iW,
					["buffTimeMarker"] = GetTime(),
					["buffTexture"] = "Interface\\Icons\\Ability_Poisons",
				}
				table.insert(suiData.unit[i].Weapon, tempDB)
				iW = iW + 1
			end
		end
		DEFAULT_CHAT_FRAME:AddMessage("Conjured buffs for "..suiData.unit[i].unit..".  "..(iB-1).." buffs, "..(iD-1).." debuffs, and "..(iW-1).." weapon buffs.", 0.5, 0.5, 0.5)
		Sui_BuffPopulate(suiData.unit[i].unit)
		i = i + 1
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Show/Hides the party leader icon on unit frames.							|--
-----------------------------------------------------------------------------------------------
function Sui_Unit_UpdatePartyLeader()
	SUI_Self_LeaderIcon:Hide()
	SUI_Party1_LeaderIcon:Hide()
	SUI_Party2_LeaderIcon:Hide()
	SUI_Party3_LeaderIcon:Hide()
	SUI_Party4_LeaderIcon:Hide()
	SUI_Target_LeaderIcon:Hide()
	if UnitIsPartyLeader("player") then
		SUI_Self_LeaderIcon:Show()
	elseif UnitIsPartyLeader("party1") then
		SUI_Party1_LeaderIcon:Show()
	elseif UnitIsPartyLeader("party2") then
		SUI_Party2_LeaderIcon:Show()
	elseif UnitIsPartyLeader("party3") then
		SUI_Party3_LeaderIcon:Show()
	elseif UnitIsPartyLeader("party4") then
		SUI_Party4_LeaderIcon:Show()
	end
	if UnitIsPartyLeader("target") then
		SUI_Target_LeaderIcon:Show()
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Show/Hides master looter icon on unit frames.								|--
-----------------------------------------------------------------------------------------------
function Sui_Unit_UpdateLootMethod()
	local lootMethod, lootMaster = GetLootMethod()
	if ( lootMaster == 0 and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) ) then
		SUI_Self_MasterIcon:Show()
	else
		SUI_Self_MasterIcon:Hide()
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Show/Hides PvP status icons on unit frames.									|--
-----------------------------------------------------------------------------------------------
function Sui_Unit_UpdatePvPStatus()
	Sui_Unit_UpdatePVPSubtask("player", SUI_Self_PVPIcon)
	Sui_Unit_UpdatePVPSubtask("party1", SUI_Party1_PVPIcon)
	Sui_Unit_UpdatePVPSubtask("party2", SUI_Party2_PVPIcon)
	Sui_Unit_UpdatePVPSubtask("party3", SUI_Party3_PVPIcon)
	Sui_Unit_UpdatePVPSubtask("party4", SUI_Party4_PVPIcon)
	Sui_Unit_UpdatePVPSubtask("target", SUI_Target_PVPIcon)
end

function Sui_Unit_UpdatePVPSubtask(toon, texture)
	local factionGroup, factionName = UnitFactionGroup(toon)
	if ( UnitIsPVPFreeForAll(toon) ) then
		texture:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
		texture:Show()
	elseif ( factionGroup and UnitIsPVP(toon) ) then
		texture:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup)
		texture:Show()
	else
		texture:Hide()
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Show/Hides attack/resting icons on unit frames.								|--
-----------------------------------------------------------------------------------------------
function Sui_Unit_UpdateStatus_Subtask(toon, attackicon, resticon)
	if UnitExists(toon) then
		if IsResting() and toon=="player" then
			attackicon:Hide()
			resticon:Show()
		elseif (UnitAffectingCombat(toon)) then
			attackicon:Show()
			resticon:Hide()
		else
			attackicon:Hide()
			resticon:Hide()
		end
	end
end

function Sui_Unit_UpdateStatus()
	Sui_Unit_UpdateStatus_Subtask("player", SUI_Self_AttackIcon, SUI_Self_RestIcon)
	Sui_Unit_UpdateStatus_Subtask("party1", SUI_Party1_AttackIcon, SUI_Party1_RestIcon)
	Sui_Unit_UpdateStatus_Subtask("party2", SUI_Party2_AttackIcon, SUI_Party2_RestIcon)
	Sui_Unit_UpdateStatus_Subtask("party3", SUI_Party3_AttackIcon, SUI_Party3_RestIcon)
	Sui_Unit_UpdateStatus_Subtask("party4", SUI_Party4_AttackIcon, SUI_Party4_RestIcon)
	Sui_Unit_UpdateStatus_Subtask("target", SUI_Target_AttackIcon, SUI_Target_RestIcon)
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Show/Hides AFK status icon on unit frames.									|--
-----------------------------------------------------------------------------------------------
function Sui_Unit_UpdateAFK_Subtask(toon, toonID)
	local kind = type(toonID)
	if kind == "string" then
		toonID = tonumber(toonID)
	end
	if toonID<=6 then
		local icon = _G[suiData.unit[toonID].frame .. "_ReadyMaybe"]
		if UnitIsAFK(toon) then
			icon:SetTexture("Interface\\AddOns\\SpartanUI\\Textures\\Icon_AFK.blp")
			icon:SetHeight(32)
			icon:Show()
		else
			icon:Hide()
			icon:SetHeight(70)
			icon:SetTexture("Interface\\AddOns\\SpartanUI\\Textures\\Icon_Readycheck_Maybe.blp")
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Determines the level of pet happiness.										|--
-----------------------------------------------------------------------------------------------
function Sui_Pet_UpdateHappiness()
	local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
	local hasPetUI, isHunterPet = HasPetUI()
	if ( not happiness or not isHunterPet ) then
		SUI_Pet_HappinessIcon:Hide()
		return
	end
	SUI_Pet_HappinessIcon:Show()
	if ( happiness == 1 ) then
		SUI_Pet_HappinessIcon:SetTexCoord(0.375, 0.5625, 0, 0.359375)
	elseif ( happiness == 2 ) then
		SUI_Pet_HappinessIcon:SetTexCoord(0.1875, 0.375, 0, 0.359375)
	elseif ( happiness == 3 ) then
		SUI_Pet_HappinessIcon:SetTexCoord(0, 0.1875, 0, 0.359375)
	end
		PetFrameHappiness.tooltip = getglobal("PET_HAPPINESS"..happiness)
		PetFrameHappiness.tooltipDamage = format(PET_DAMAGE_PERCENTAGE, damagePercentage)
	if ( loyaltyRate < 0 ) then
		PetFrameHappiness.tooltipLoyalty = getglobal("LOSING_LOYALTY")
	elseif ( loyaltyRate > 0 ) then
		PetFrameHappiness.tooltipLoyalty = getglobal("GAINING_LOYALTY")
	else
		PetFrameHappiness.tooltipLoyalty = nil
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Calls a function after a particular time delay predefined by function args.	|--
--|				functionName: the name of the function to call								|--
--|				parameters: the parameters for the function to call							|--
--|				timeDealy: the delay before the function gets called						|--
-----------------------------------------------------------------------------------------------
function Sui_DelayedCall(functionName, parameters, timeDelay)
	if not functionName then
		if suiData.delayedCalls and suiData.delayedCalls[1] then
			local i = 1
			while i and i<5 do
				if suiData.delayedCalls[i] and suiData.delayedCalls[i][3] <= GetTime() then
					_G[suiData.delayedCalls[i][1]](unpack(suiData.delayedCalls[i][2]))
					-- DEFAULT_CHAT_FRAME:AddMessage(suiData.delayedCalls[i][1].." called.", 0.5, 0.5, 0.5)
					table.remove(suiData.delayedCalls, i)
				elseif suiData.delayedCalls[(i+1)] then
					i = i + 1
				else
					i = nil
				end
			end
		end
	else
		local i, p = {}

		if not parameters or type(parameters)=="number" then
			p = {"_"}
		else
			p = {strsplit(",", parameters)}
		end
		table.insert(i, functionName)
		table.insert(i, p)
		table.insert(i, (timeDelay + GetTime()))
		if not suiData.delayedCalls then
			suiData.delayedCalls = {}
		end
		table.insert(suiData.delayedCalls, i)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	SpinCam control.  Woohoo! :D												|--
-----------------------------------------------------------------------------------------------
function Sui_SpinCam()
	local toggle = GetCVar("autoClearAFK")
	if toggle=="0" then
		return
	elseif toggle=="1" then
		if suiData.isSpinning==0 then
			SetCVar("cameraYawMoveSpeed","7.33")
			MoveViewRightStart()
			SetView(5)
		elseif suiData.isSpinning==1 then
			MoveViewRightStop()
			SetCVar("cameraYawMoveSpeed","230")
			SetView(5)
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Adds additional info if MobInfo is present.									|--
-----------------------------------------------------------------------------------------------
function Sui_MobTip()
	if IsAddOnLoaded("MobInfo2")==1 then
    	local mobData = MI2_GetMobData( UnitName("target"), UnitLevel("target"), "target" )
    	if mobData~=nil then
			local typeMob
			if UnitCreatureType("target") then
				if mobData.mobType==3 then
					typeMob = " Boss "..UnitCreatureType("target")
				elseif mobData.mobType==2 then
					typeMob = " Elite "..UnitCreatureType("target")
				else
					typeMob = " Mob "..UnitCreatureType("target")
				end
			end

    		local rtn = "\r"
			local text = "|cffffc100"..UnitName("target").."|r\r"..UnitLevel("target")..typeMob..rtn..rtn.."Health: "..(mobData.healthMax or "_")..rtn.."Mana: "..(UnitManaMax("target") or "_")..rtn.."Damage: "..(mobData.minDamage or "_").." - "..(mobData.maxDamage or "_")..rtn.."XP: "..(mobData.xp or "_")

			SUI_MouseTooltip_Text:SetText(text)
   		end
    end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Boss health tracker.  Shouldnt be here, but oh well.						|--
-----------------------------------------------------------------------------------------------
function TrackHealthOff()
	if not Boss_LowestHealth or Boss_LowestHealth==0 then
		Boss_LowestHealth = (UnitHealth("focus") / UnitHealthMax("focus")) *100
	end
	local CurrentHealth = (UnitHealth("focus") / UnitHealthMax("focus")) * 100

	if CurrentHealth < Boss_LowestHealth then
		Boss_LowestHealth = CurrentHealth
	end

	SUI_TestString:SetText(Boss_LowestHealth)
	if BossLowestHealth==Dead then
		BossLowestHealth=0
		SUI_TestString:SetText("Focus has died!")
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Dev tool.  Finds events registered to X frame.								|--
-----------------------------------------------------------------------------------------------
function Sui_FindEvents(arg1)
	local framename = getglobal(arg1)
	if framename then
		SUI_MouseTooltip_Text:SetText("|cffffc100"..arg1.." registered events: |r\r")
		Sui_Events = {}
		i = 0
		for v in pairs(DevTools_Events) do
			i = i + 1
			Sui_Events[i] = v
		end

		local t = Sui_Events
		table.sort(t, AlphabeticSort)
		for i,v in ipairs(t) do
			local isRegistered = framename:IsEventRegistered(v)
			if isRegistered then
				local text = SUI_MouseTooltip_Text:GetText()
				local text = text..v.."\r"
				SUI_MouseTooltip_Text:SetText(text)
			end
		end

		SUI_MouseTooltip:Show()
	else
		DEFAULT_CHAT_FRAME:AddMessage(arg1.." could not be found or was not a frame.", 1, .2, 0.2)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Dev tool.  Finds child frames of X frame.									|--
-----------------------------------------------------------------------------------------------
function Sui_FindChildren(arg1)
	local framename = getglobal(arg1)
	if framename then
		local text
		varDB, i = {framename:GetChildren()}, 1
		for k,v in pairs(varDB) do
			local q = v:GetName()
			text = (text or "|cffffc100List of Children:|r").."\r "..k..": "..(q or "")
		end
		SUI_MouseTooltip_Text:SetText(text)
		if SUI_MouseTooltip_Text:GetText()==nil then
			SUI_MouseTooltip_Text:SetText("No children found for ".. arg1)
		end
		SUI_MouseTooltip:Show()
	else
		DEFAULT_CHAT_FRAME:AddMessage(arg1.." could not be found or was not a frame.", 1, .2, 0.2)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Used for sorting tables alphabetically.										|--
-----------------------------------------------------------------------------------------------
function AlphabeticSort(a, b)
	return a<b
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Cuts the chatter of NPCs from your chatwindow.								|--
-----------------------------------------------------------------------------------------------
function Sui_Chatter(arg1)
	if arg1=="on" then
		ChatFrame1:RegisterEvent("CHAT_MSG_MONSTER_SAY")
		DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Chatter on", 0.5, 0.5, 0.5)
		suiData.chatter = false
	elseif arg1=="off" then
		ChatFrame1:UnregisterEvent("CHAT_MSG_MONSTER_SAY")
		DEFAULT_CHAT_FRAME:AddMessage("SpartanUI: Chatter off", 0.5, 0.5, 0.5)
		suiData.chatter = true
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Based on user screen ratio, sets the scale automatically.					|--
-----------------------------------------------------------------------------------------------
function Sui_ResDetect()
	local resolution = ({GetScreenResolutions()})[GetCurrentResolution()]
	local _, _, x, y = string.find(resolution, "(%d+)x(%d+)")
	local ratio = tonumber(x) / tonumber(y)

	-- For Standard 16:9 Widescreen (1920 x 1080 etc.)
	if ratio < 1.8 and GetCVar("useUiScale") == "1" then
		SetCVar("uiScale", "0.75")
		suiData.scale = .80

	elseif ratio < 1.8 and GetCVar("useUiScale") == "0" then
		SetCVar("uiScale", "0.75")
		suiData.scale = .64

	-- for Ultra 21:9 Widescreen (2560 x 1080 etc.)
	elseif ratio > 2.3 and GetCVar("useUiScale") == "1" then
		SetCVar("uiScale", "0.75")
		suiData.scale = .95

	elseif ratio > 2.3 and GetCVar("useUiScale") == "0" then
		SetCVar("uiScale", "0.75")
		suiData.scale = .80
	end
	SpartanUI:SetScale(suiData.scale)
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	For simple warning messages.												|--
-----------------------------------------------------------------------------------------------
function Sui_MessageFlasher(message, flash, fade)
	local f = CreateFrame("Frame", "SUI_MessageFlasher", UIParent)
	f:SetWidth(500)
	f:SetHeight(125)
	f:SetFrameStrata("HIGH")
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	local t = f:CreateTexture(nil, "ARTWORK")
	t:SetTexture(0,0,0, 0.80)
	t:SetAllPoints(f)
	local s = f:CreateFontString("SUI_MessageFlasher_String","OVERLAY")
	s:SetPoint("CENTER", f, "CENTER")
	s:SetFontObject(SUI_FontTitle16)
	s:SetText(message)
	if flash then
		UIFrameFlash(f, 0.25, .25, -1, true, 0, 4)
	end
	if fade then
		UIFrameFlash(f, 0, 5, 10, false, 0, 5)
		-- UIFrameFlash(frame, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime)
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Ye old big list of events.  X(												|--
--|	 Note:		From what I am told, my methodology here is outdated.						|--
-----------------------------------------------------------------------------------------------
function Sui_OnEvent()
	if event=="ADDON_LOADED" then
		if arg1=="Blizzard_BindingUI" then
			local i = 1
			while _G["KeyBindingFrameBinding"..i.."Description"] do
				_G["KeyBindingFrameBinding"..i.."Description"]:SetTextColor(1, .65, 0)
				_G["KeyBindingFrameBinding"..i.."Description"]:SetFontObject(SUI_Multilingual)
				i = i + 1
			end
		end
	elseif event=="CHAT_MSG_ADDON" then
		if arg1=="SUI" then
			local task, caller, subject, value = strsplit(" ", arg2)	-- parse the message into variables
			-- DEFAULT_CHAT_FRAME:AddMessage("task: "..task.." | caller: "..caller.." | subject: "..subject.." | value: ".. value, 0.5, 0.5, 0.5)
			if task=="find" then
				if subject=="spec" then
					Sui_FindSpecInfo(UnitName("player"), caller)
				elseif subject=="version" then
					SendAddonMessage("SUI", "deliver "..UnitName("player").." "..subject.." "..SUI_currentVersion, "WHISPER", caller)
				elseif subject=="performance" then
					local fps, suiCPUTime, timestamp = math.floor(GetFramerate()), GetAddOnCPUUsage("SpartanUI"), suiData.AFKTimestamp
					local down, up, lag = GetNetStats()
					if type(suiData.AFKTimestamp)=="number" then
						timestamp = GetTime() - timestamp
					elseif not timestamp then
						timestamp = "not"
					end
					SendAddonMessage("SUI", "deliver "..UnitName("player").." "..subject.." "..lag.."|"..fps.."|"..suiCPUTime.."|"..timestamp.."|"..suiCPUTime, "WHISPER", caller)
				elseif subject=="petname" then
					SUI_Pet_Name:SetText(UnitName("pet"))
					if UnitName("pet")==UNKNOWNOBJECT then
						SendAddonMessage("SUI", "find "..UnitName("player").." petname".." ".."unknown", "WHISPER", UnitName("player"))
					end
				end
			elseif task=="deliver" then
				if subject=="spec" then
					Sui_DeliverSpecInfo(value)
				elseif subject=="version" then
					DEFAULT_CHAT_FRAME:AddMessage(caller ..": ".. value, 0.65, 0.65, 0.65)
				elseif subject=="performance" then
					local lag, fps, suiCPUTime, timestamp = strsplit("|", value)
					if tonumber(timestamp) then
						timestamp = SecondsToTime((tonumber(timestamp)))
					end
					DEFAULT_CHAT_FRAME:AddMessage(caller..": Latency="..lag..", FPS="..fps..", AFK="..timestamp.." | "..suiCPUTime, 0.65, 0.65, 0.65)
				elseif subject=="AFK" then
					local toonID
					for v=3, 6, 1 do
						if UnitIsUnit(suiData.unit[v].unit, caller) then
							toonID = v
							if value=="true" then
								Sui_DelayedCall("Sui_Unit_UpdateAFK_Subtask", caller..","..toonID, 5)
							elseif value=="false" then
								Sui_DelayedCall("Sui_Unit_UpdateAFK_Subtask", caller..","..toonID, 5)
							end
							break
						end
					end
				end
			end
		end
	elseif event=="CHAT_MSG_COMBAT_FACTION_CHANGE" then
		local reputation_, with_, f1_, f2_, f3_ = strsplit(" ", arg1)
		suiData.currentFaction = f1_
		if f2_~="increased" then
			suiData.currentFaction = suiData.currentFaction.." "..(f2_ or "unknown")
			if f3_~="increased" then
				suiData.currentFaction = suiData.currentFaction.." "..(f3_ or "unknown")
			end
		end
		if (GetWatchedFactionInfo())~=suiData.currentFaction then
			for factionIndex = 1, GetNumFactions() do
				local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, isWatched = GetFactionInfo(factionIndex)
				suiData.factionDescription = description
				suiData.factionIndex = factionIndex
				if name==(suiData.currentFaction or "none") then
					SetWatchedFactionIndex(factionIndex)
					Sui_RepBar()
				end
			end
		end
	elseif event=="CHAT_MSG_COMBAT_XP_GAIN" then
		SUI_mobXP = string.match(arg1, "%d+")
		local a, b = string.find(arg1, " dies")
		local test = strsplit(" ", arg1)
		if test~="You" and a then
			SUI_mobLast = string.sub(arg1, 1, a-1)
		end
	elseif event=="CHAT_MSG_SYSTEM" then
		if ( arg1 == "You are now AFK: Away from Keyboard" ) then
			suiData.isSpinning = 0
			suiData.AFKTimestamp = GetTime()
			Sui_SpinCam()
			if UnitInParty("player") then
				SendAddonMessage("SUI", "deliver "..UnitName("player").." AFK true", "PARTY")
			end
		elseif ( arg1 == "You are no longer AFK.") then
			suiData.isSpinning = 1
			suiData.AFKTimestamp = "not"
			Sui_SpinCam()
			if UnitInParty("player") then
				SendAddonMessage("SUI", "deliver "..UnitName("player").." AFK false", "PARTY")
			end
		end
	elseif event=="COMBAT_LOG_EVENT" then
		if suiData.buffToggle == "on" then
			-- DEFAULT_CHAT_FRAME:AddMessage("1: "..arg1.." | 2: "..arg2.." | 3: "..arg3.."\r| 4: "..(arg4 or "nil").." | 5: "..(arg5 or "nil").." | 6: "..(arg6 or "nil").." | 7: "..(arg7 or "nil"), 0.5, 0.5, 0.5)
			if arg2=="ENCHANT_APPLIED" and arg7==(UnitName("player")) then
				if TemporaryEnchantFrame then
					TemporaryEnchantFrame:Hide()
					TemporaryEnchantFrame:SetAlpha(0)
				end
				Sui_DelayedCall("Sui_BuffScan", "player", 1)
			elseif arg2=="ENCHANT_REMOVED" and arg7==(UnitName("player")) then
				Sui_DelayedCall("Sui_BuffScan", "player", 1)
			end
		end
	elseif event=="INSPECT_TALENT_READY" then
		Sui_GetSpec("target", true)
	elseif event=="UNIT_AURA" then
		if suiData.buffToggle == "on" then
			Sui_BuffScan(arg1)
			if UnitExists("targettarget") then
				Sui_BuffScan("targettarget")
			end
		end
	elseif event=="UNIT_LEVEL" then
		local toonID = Sui_DeriveUnit(arg1, "number", 10)
		if not toonID then return end
		if _G[suiData.unit[toonID].frame .. "_Level"] then
			_G[suiData.unit[toonID].frame .. "_Level"]:SetText(UnitLevel(arg1))
		end
		if arg1=="player" then
			SUI_XP_CurrentLevel:SetText("Level: "..UnitLevel("player"))
		end
	elseif event=="UNIT_HEALTH" or event=="UNIT_MANA" or event=="UNIT_RAGE" or event=="UNIT_ENERGY" then
		Sui_SetupMembers(arg1, "update")
		if UnitExists("targettarget") then
    		Sui_SetupMembers("targettarget", "update")
    	end
	elseif event=="UNIT_FOCUS" then
		Sui_SetupMembers("pet", "update")
		if UnitIsUnit("target", "pet") then
			Sui_SetupMembers("target", "update")
		end
		if UnitIsUnit("targettarget", "pet") then
			Sui_SetupMembers("targettarget", "update")
		end
	elseif event=="UNIT_PET" then
		Sui_DelayedCall("Sui_SetupMembers", "pet,setup", 0)
	elseif event=="UNIT_PORTRAIT_UPDATE" then
		local toonID = Sui_DeriveUnit(arg1, "number", 10)
		if not toonID then return end
		if _G[suiData.unit[toonID].frame.."_Portrait"] then
			SetPortraitTexture(_G[suiData.unit[toonID].frame.."_Portrait"], arg1)
		end
		if arg1=="player" then
			SetPortraitTexture(SUI_XP_Portrait,arg1)
		elseif arg1=="target" and UnitExists("targettarget") then
			SetPortraitTexture(SUI_TOT_Portrait,"targettarget")
		end
	elseif event=="UPDATE_FACTION" then
		Sui_RepBar()
		if BT3BarREPUTATION then
			if BT3BarREPUTATION:IsVisible() then
				BT3BarREPUTATION:Hide()
			end
		end
	elseif event=="UNIT_FACTION" then
		if ( arg1 == "player" ) then
			Sui_Unit_Update(arg1)
		end
	elseif event=="UNIT_HAPPINESS" then
		Sui_Pet_UpdateHappiness()
	elseif event=="PLAYER_AURAS_CHANGED" then
		if suiData.buffToggle == "on" then
			Sui_BuffScan("player")
		end
	elseif event=="PARTY_MEMBERS_CHANGED" or event=="PARTY_LEADER_CHANGED" then
		Sui_Unit_Update()
		Sui_SetupMembers("all", "setup")
		if not UnitExists("target") then
			SUI_TargetFrame:Hide()
		end
		Sui_UpdatePartyVisibility();
	elseif event=="PARTY_LOOT_METHOD_CHANGED" then
		Sui_Unit_Update()
	elseif event=="PLAYER_ALIVE" then
	elseif event=="PLAYER_COMBO_POINTS" then
		Sui_UpdateComboPoints()
	elseif event=="PLAYER_DEAD" then
		if godmode==1 then
			DEFAULT_CHAT_FRAME:AddMessage("Gee, I guess that feature isn't working yet. :(", 0.5, 0.5, 0.5)
			DEFAULT_CHAT_FRAME:AddMessage("Exiting God Mode.", 1, 0, 0)
			godmode=0
		end
	elseif event=="PLAYER_ENTER_COMBAT" then
		Sui_ReadyCheck("finish")
		Sui_Unit_Update()
	elseif event=="PLAYER_LEAVE_COMBAT" then
		Sui_Unit_Update()
	elseif event=="PLAYER_FLAGS_CHANGED" then
		local toonID = Sui_DeriveUnit(arg1, "number", 6)
		if not toonID then return end
		Sui_Unit_UpdateAFK_Subtask(suiData.unit[toonID].unit, toonID)
	elseif event=="PLAYER_FOCUS_CHANGED" then
		Sui_FocusUpdate()
	elseif event=="PLAYER_ENTERING_WORLD" then
		Sui_SetupMembers("all", "setup")
		Sui_XPBar()
		Sui_Unit_Update()
		MultiBarBottomLeft:Hide()
		MultiBarBottomRight:Hide()
		MultiBarLeft:Hide()
		MultiBarRight:Hide()
		local inInstance, instanceType = IsInInstance()
		if inInstance==1 then
			SUI_MinimapCoords:Hide()
		elseif not inInstance then
			SUI_MinimapCoords:Show()
    	SetMapToCurrentZone()
    end
    FramerateLabel:ClearAllPoints()
		FramerateLabel:SetPoint("CENTER", "WorldFrame", "BOTTOM", -15, 125)
		FramerateLabel:SetFontObject(SUI_FontLevel)
		FramerateText:SetFontObject(SUI_FontLevel)
		-- Fix for CT_BarMod
		if IsAddOnLoaded("CT_BarMod")==1 then
			local i = 1
			while i <= 120 do
				local frame = _G["CT_BarModActionButton"..i]
				if frame then
					frame:Hide()
				end
				i = i + 1
			end
			Sui_MessageFlasher("CT_BarMod cannot be used with SpartanUI.", false, true)
		end
		-- Fix for Titan
		if IsAddOnLoaded("Titan")==1 then
			local unitServer = UnitName("player").."@"..GetRealmName()
			if SUI_Titan then
				TitanSettings.Players[unitServer].Panel.MinimapAdjust = 1
			else
				SUI_Titan = true
				Sui_MessageFlasher("Please reload or relog to fix the minimap icons.", true)
			end
		end
		_, englishClass = UnitClass("player")
		if englishClass=="HUNTER" then
			Sui_SetupMembers("pet","setup")
		end
		Sui_Bartender()
		Sui_Bartender()
	elseif event=="PLAYER_LEAVING_WORLD" then
		SetCVar("cameraYawMoveSpeed","230")
		MoveViewRightStop()
	elseif event=="PLAYER_REGEN_DISABLED" then
		Sui_ReadyCheck("finish")
		Sui_Unit_Update()
	elseif event=="PLAYER_REGEN_ENABLED" then
		Sui_Unit_Update()
	elseif event=="PLAYER_TARGET_CHANGED" then
		suiData.lastTarget = suiData.newTarget or 0 -- on your first target, your last target will be nil
		suiData.newTarget = UnitGUID("target") or 0 -- when a mob dies, your new target will be nil
		suiData.lastTarget_checked = 0
		SUI_MouseTooltip_Text:SetText("Not available.")
		if not InCombatLockdown() then
			TargetFrame:Hide()
		end
		Sui_SetupMembers("target", "setup")
		if UnitExists("targettarget") then
			Sui_SetupMembers("targettarget", "setup")
    	else
    		SUI_TOT:Hide()
		end
		Sui_Unit_Update()
		Sui_UpdateComboPoints()

		local wildcard = "isCasting"
		local spellCast, rankCast  = UnitCastingInfo("target")
		local spellChan, rankChan  = UnitChannelInfo("target")
		if spellCast then
			Sui_InitCastMath("target", spellCast, rankCast, wildcard, 1)
		else
			Sui_InitCastMath("target", _, _, wildcard, 0)
		end
		wildcard = "isChanneling"
		if spellChan then
			Sui_InitCastMath("target", spellChan, rankChan, wildcard, 1)
		else
			Sui_InitCastMath("target", _, _, wildcard, 0)
		end

		if not UnitIsPlayer("target") then
			Sui_MobTip()
		end
	elseif event=="PLAYER_UPDATE_RESTING" then
		Sui_Unit_Update()
	elseif event=="PLAYER_XP_UPDATE" then
		Sui_XPBar()
	elseif event=="QUEST_LOG_UPDATE" then
		QuestWatchFrame:ClearAllPoints()
		QuestWatchFrame:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -20, 200)
		QuestTimerFrame:ClearAllPoints()
		QuestTimerFrame:SetPoint("BOTTOM", "UIParent", "BOTTOM", 0, 250)
		DurabilityFrame:ClearAllPoints()
		DurabilityFrame:SetPoint("BOTTOM", "SUI_MapOverlay", "TOP", 0, 0)
	elseif event=="RAID_ROSTER_UPDATE" then
		Sui_UpdatePartyVisibility();
	elseif event=="RAID_TARGET_UPDATE" then
		Sui_RaidIcon()
	elseif event=="READY_CHECK" then
		Sui_ReadyCheck(arg1, nil, arg2)
	elseif event=="READY_CHECK_CONFIRM" then
		Sui_ReadyCheck(arg1, arg2)
	elseif event=="READY_CHECK_FINISHED" then
		Sui_ReadyCheck("finish")
	elseif event=="TIME_PLAYED_MSG" then
		if not suiData.xpSetup then
			suiData.totalTime, suiData.currentTime = arg1, arg2
			ChatFrame1:RegisterEvent("TIME_PLAYED_MSG")
			suiData.xpSetup = true
			Sui_XPBar()
		end
	elseif event=="UPDATE_SHAPESHIFT_FORMS" then
		Sui_BarFix()
	elseif event=="UNIT_SPELLCAST_START" then									-- cast start
		CastingBarFrame:Hide()
		if arg2~="LOGINEFFECT" then
			Sui_InitCastMath(arg1, arg2, arg3, "isCasting", 1)
		end
	elseif event=="UNIT_SPELLCAST_STOP" then									-- cast stop
		if arg2~="LOGINEFFECT" then
			Sui_InitCastMath(arg1, arg2, arg3, "isCasting", 0)
		end
	elseif event=="UNIT_SPELLCAST_CHANNEL_START" then							-- channel start
		CastingBarFrame:Hide()
		Sui_InitCastMath(arg1, arg2, arg3, "isChanneling", 1)
	elseif event=="UNIT_SPELLCAST_CHANNEL_STOP" then							-- channel stop
		Sui_InitCastMath(arg1, arg2, arg3, "isChanneling", 0)
	elseif event=="UNIT_SPELLCAST_INTERRUPTED" then								-- spell failed
	elseif event=="UNIT_SPELLCAST_FAILED" then									-- spell not ready
	elseif event=="UNIT_SPELLCAST_DELAYED" then									-- a real interruption (but for casts only)
		local toonID = Sui_DeriveUnit(arg1, "number", 10)
		if not toonID then return end
		local spellName, _, _, _, startTime, endTime, other = UnitCastingInfo(arg1)
		if endTime then
			suiData.unit[toonID].spellEnd = endTime/1000
		end
	elseif event=="UNIT_SPELLCAST_CHANNEL_UPDATE" then 							-- a real interruption (but for channel only)
		local toonID = Sui_DeriveUnit(arg1, "number", 10)
		if not toonID then return end

		local spellName, _, _, _, startTime, endTime, other = UnitChannelInfo(arg1)
		suiData.unit[toonID].spellEnd = endTime/1000
	elseif event=="VARIABLES_LOADED" then
		if not suiData then
			Sui_InitializeVariables(false)
		end
		if not suiData.dbVersion then
			Sui_InitializeVariables(false)
		elseif suiData.dbVersion < 2.13 then
			Sui_InitializeVariables(false)
		elseif suiData.dbVersion < SUI_currentVersion or SUI_devmode==true then
			Sui_InitializeVariables(true)
		end
		suiData.delayedCalls = nil
		Sui_InitializeLanguages()
		Sui_Setup()
	elseif event=="VOICE_START" or event=="VOICE_PUSH_TO_TALK_START" then
		local toonID = Sui_DeriveUnit(arg1, "number", 6)
		if not toonID then toonID=1 end
		_G[suiData.unit[toonID].frame .. "_VoiceIcon"]:Show()
	elseif event=="VOICE_STOP" or event=="VOICE_PUSH_TO_TALK_STOP" then
		local toonID = Sui_DeriveUnit(arg1, "number", 6)
		if not toonID then toonID=1 end
		_G[suiData.unit[toonID].frame .. "_VoiceIcon"]:Hide()
	elseif event=="ZONE_CHANGED" then
		local inInstance, instanceType = IsInInstance()
		if inInstance==1 then
			SUI_MinimapCoords:Hide()
		elseif not inInstance then
			SUI_MinimapCoords:Show()
    	SetMapToCurrentZone()
    end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Offsets the HUD to compensate for FuBar/Titan panels.						|--
-----------------------------------------------------------------------------------------------
function SUI_PanelOffSet()
	local offset = 0
	if suiData.fubar1 == true then
		offset = offset + FuBarFrame1:GetHeight()
	end
	if suiData.fubar2 == true then
		offset = offset + FuBarFrame2:GetHeight()
	end
	if suiData.titan1 == true then
		offset = offset + TitanPanelBarButton:GetHeight()
	end
	if suiData.titan2 == true then
		offset = offset + TitanPanelAuxBarButton:GetHeight()
	end
	SpartanUI:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, offset)
	SpartanUI:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, offset)
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Handles the readycheck.														|--
--|  Arguments:	toon = name of toon who is ready or name of toon requesting readycheck		|--
--|				ready = 1 or 0 (ready or not)												|--
--|				timeout = time remaining before readycheck automatically completes			|--
-----------------------------------------------------------------------------------------------
function Sui_ReadyCheck(toon, ready, timeout)
	-- READY_CHECK_FINISHED
	local frame, toonID
	if toon=="finish" or not toon then
		for toonID = 1, 10, 1 do
			if _G[suiData.unit[toonID].frame.."_ReadyYes"] then
				_G[suiData.unit[toonID].frame.."_ReadyYes"]:Hide()
				_G[suiData.unit[toonID].frame.."_ReadyMaybe"]:Hide()
				_G[suiData.unit[toonID].frame.."_ReadyNo"]:Hide()
			end
		end
	-- READY_CHECK
	elseif timeout then
		suiData.readyCheck = toon
		if UnitIsUnit(toon, "player") then
			Sui_DelayedCall("Sui_ReadyCheck", "finish", timeout)
			for toonID = 1, 10, 1 do
				if UnitIsUnit(toon, suiData.unit[toonID].unit) then
					_G[suiData.unit[toonID].frame.."_ReadyYes"]:Show()
					_G[suiData.unit[toonID].frame.."_ReadyMaybe"]:Hide()
				elseif _G[suiData.unit[toonID].frame.."_ReadyMaybe"] then
					_G[suiData.unit[toonID].frame.."_ReadyMaybe"]:Show()
				end
			end
		end
	-- READY_CHECK_CONFIRM
	elseif ready then
		if UnitIsUnit(suiData.readyCheck, "player") then
			if UnitInParty("player") then
				toon = "party"..toon
			elseif UnitInRaid("player") then
				toon = "raid"..toon
			end
			local toonID = Sui_DeriveUnit(toon, "number", 10)
			if not toonID then return end
			if ready==1 then
				_G[suiData.unit[toonID].frame.."_ReadyYes"]:Show()
				_G[suiData.unit[toonID].frame.."_ReadyMaybe"]:Hide()
			elseif ready==0 then
				_G[suiData.unit[toonID].frame.."_ReadyNo"]:Show()
				_G[suiData.unit[toonID].frame.."_ReadyMaybe"]:Hide()
			end
		end
	end
end
-----------------------------------------------------------------------------------------------
--|  Purpose:	Time delineated operations.  Split in 1, 12.5, and 32 FPS sections.			|--
-----------------------------------------------------------------------------------------------
function Sui_OnUpdate(self, elapsed)
	Sui_ManageFrames()
	Sui_Bags()
	if suiData then
		suiData.GeneralInterval = suiData.GeneralInterval + elapsed
		suiData.FrequentInterval = suiData.FrequentInterval + elapsed
		suiData.AnimationInterval = suiData.AnimationInterval + elapsed
		suiData.FastInterval = suiData.FastInterval + elapsed
		if (suiData.GeneralInterval > suiData.UpdateInterval) then				-- 1FPS
			suiData.GeneralInterval = 0

			Sui_DelayedCall() -- DelayedCall runs functions that are time-delayed.
			-- Sui_BuffUpdate() -- progress bar and countdown updates
			if suiData.tooltipUpdate==true then
				Sui_BuffTooltip_Enter()
			end

			if IsAddOnLoaded("FuBar")==1 or IsAddOnLoaded("Titan")==1 then
				if FuBarFrame1 then
					if FuBarFrame1:GetPoint()=="BOTTOMLEFT" and FuBarFrame1:IsVisible() then
						suiData.fubar1 = true
					else
						suiData.fubar1 = false
					end

					if FuBarFrame2 then
						if FuBarFrame2:GetPoint()=="BOTTOMLEFT" and FuBarFrame2:IsVisible() then
							suiData.fubar2 = true
						else
							suiData.fubar2 = false
						end
					end
				end
				if TitanPanelBarButton then
					if TitanPanelBarButton:GetPoint()=="TOPRIGHT" and TitanPanelBarButton:IsVisible() then
						suiData.titan1 = true
					else
						suiData.titan1 = false
					end
				end
				if TitanPanelAuxBarButton then
					local point, relativeTo, relativePoint, xOfs, yOfs = TitanPanelAuxBarButton:GetPoint()
					if point=="TOPRIGHT" and yOfs > 0 then
						suiData.titan2 = true
					else
						suiData.titan2 = false
					end
				end

				SUI_PanelOffSet()
			end


			--|  Minimap Coords  |--
			local posX, posY = GetPlayerMapPosition("player")
			posX = (math.floor(posX * 1000)) * .1
			posY = (math.floor(posY * 1000)) * .1
			if posX==0 and posY==0 then
				local inInstance, instanceType = IsInInstance()
				if not inInstance and not WorldMapFrame:IsVisible() then
					SetMapToCurrentZone()
				end
			end
			SUI_MinimapCoords:SetText(posX.." | "..posY)

			if not SUI_FirstLoad then
				if suiData.FrameAdvance>1 then
					Sui_BarFix()
					Sui_ChatFrame("setup")
					SUI_FirstLoad=0
				end
			end

			if MouseIsOver(ChatFrame1)==1 or MouseIsOver(ChatFrame2)==1 or MouseIsOver(ChatFrame3)==1
			 or MouseIsOver(ChatFrame4)==1 or MouseIsOver(ChatFrame5)==1 or MouseIsOver(ChatFrame6)==1
			 or MouseIsOver(ChatFrame7)==1 then
				Sui_ChatFrame("show")
			else
				Sui_ChatFrame("hide")
			end
		end
		if (suiData.FrequentInterval > suiData.UpdateInterval*0.36) then		-- around 3FPS
			suiData.FrequentInterval = 0

			if UnitExists("targettarget") then
				if not suiData.unit[7].unitGUID then
					suiData.unit[7].unitGUID = UnitGUID("targettarget")
					Sui_SetupMembers("targettarget", "setup")
				end
				if suiData.unit[7].unitGUID~=UnitGUID("targettarget") then
					suiData.unit[7].unitGUID = UnitGUID("targettarget")
					Sui_SetupMembers("targettarget", "setup")
				end
			end

		end
		if (suiData.AnimationInterval > (suiData.UpdateInterval*0.08)) then		-- 12.5 FPS
			suiData.AnimationInterval = 0
			suiData.FrameAdvance = suiData.FrameAdvance + 1

			local i = 1
			while i <= 10 do
				if i~=8 and _G[suiData.unit[i].frame]:IsVisible() then
					Sui_Animation(suiData.unit[i].unit, "Health", suiData.unit[i].frame .. "_HealthBar", suiData.unit[i].healthbar_width, suiData.unit[i].healthbar_height, suiData.unit[i].direction, 3, i)
					if i~=9 then
						Sui_Animation(suiData.unit[i].unit, "Power", suiData.unit[i].frame, suiData.unit[i].powerbar_width, suiData.unit[i].powerbar_height, suiData.unit[i].direction, 3, i)
					end
				end
				i = i + 1
			end
			if (suiData.FrameAdvance < 5) then
				SUI_XP_Increase:Show()
				Sui_XPIncrease()
			elseif (suiData.FrameAdvance > 5) then
				SUI_XP_Increase:Hide()
			end
			if suiData.popUps == "on" then
				if MouseIsOver(SUI_PopLeft_Hit, 0, 0, 0, 0) == 1 then
					SUI_BarPoppupLeft_Top:Hide()
					SUI_PopLeft_Hit:Hide()
				elseif MouseIsOver(SUI_PopRight_Hit, 0, 0, 0, 0) == 1 then
					SUI_BarPoppupRight_Top:Hide()
					SUI_PopRight_Hit:Hide()
				else
					SUI_BarPoppupLeft_Top:Show()
					SUI_PopLeft_Hit:Show()
					SUI_BarPoppupRight_Top:Show()
					SUI_PopRight_Hit:Show()
				end
			elseif suiData.popUps == "off" then
				SUI_BarPoppupLeft_Top:Hide()
				SUI_PopLeft_Hit:Hide()
				SUI_BarPoppupRight_Top:Hide()
				SUI_PopRight_Hit:Hide()
			end
		end
		--|  CastBar animation  |--
		if (suiData.FastInterval > (suiData.UpdateInterval/32)) then				-- 32 FPS
			if SUI_MouseTooltip:IsVisible() then
				local x, y = GetCursorPosition()
				local realScale = (UIParent:GetEffectiveScale())*(suiData.scale)
				SUI_MouseTooltip:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x/realScale-6, y/realScale+20)
			end
			local i = 1
			while i <= 10 do
				if suiData.unit[i].isCasting==1 or suiData.unit[i].isChanneling==1 then
					Sui_Animation(suiData.unit[i].unit, "Cast", suiData.unit[i].frame .. "_CastBar", suiData.unit[i].castbar_width, suiData.unit[i].castbar_height, suiData.unit[i].direction, 1, i)
				end
				i = i + 1
			end
			suiData.FastInterval = 0
		end
	end
end
