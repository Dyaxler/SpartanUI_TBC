--[[ $Id: PetBar.lua 77829 2008-07-05 12:41:16Z nevcairiel $ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")
-- register module
local PetBarMod = Bartender4:NewModule("PetBar", "AceEvent-3.0")

-- fetch upvalues
local ActionBars = Bartender4:GetModule("ActionBars")
local ButtonBar = Bartender4.ButtonBar.prototype

-- create prototype information
local PetBar = setmetatable({}, {__index = ButtonBar})

local defaults = { profile = Bartender4:Merge({
	enabled = true,
	scale = 1.0,
}, Bartender4.ButtonBar.defaults) }

function PetBarMod:OnInitialize()
	self.db = Bartender4.db:RegisterNamespace("PetBar", defaults)
	self:SetEnabledState(self.db.profile.enabled)
end

function PetBarMod:OnEnable()
	if not self.bar then
		self.bar = setmetatable(Bartender4.ButtonBar:Create("PetBar", self.db.profile, L["Pet Bar"]), {__index = PetBar})
		
		local buttons = {}
		for i=1,10 do
			buttons[i] = Bartender4.PetButton:Create(i, self.bar)
		end
		self.bar.buttons = buttons
		
		-- TODO: real positioning
		self.bar:ClearSetPoint("CENTER")
		
		self.bar:SetScript("OnEvent", PetBar.OnEvent)
		
		self.bar:SetAttribute("unit", "pet")
	end
	self.bar:Enable()
	
	RegisterUnitWatch(self.bar, false)
	
	self.bar:RegisterEvent("PLAYER_CONTROL_LOST")
	self.bar:RegisterEvent("PLAYER_CONTROL_GAINED")
	self.bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
	self.bar:RegisterEvent("UNIT_PET")
	self.bar:RegisterEvent("UNIT_FLAGS")
	self.bar:RegisterEvent("UNIT_AURA")
	self.bar:RegisterEvent("PET_BAR_UPDATE")
	self.bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
	self.bar:RegisterEvent("PET_BAR_SHOWGRID")
	self.bar:RegisterEvent("PET_BAR_HIDEGRID")
	
	self:ApplyConfig()
	self:ToggleOptions()
	
	self:RegisterEvent("UPDATE_BINDINGS", "ReassignBindings")
	self:ReassignBindings()
end

function PetBarMod:OnDisable()
	if not self.bar then return end
		
	UnregisterUnitWatch(self.bar)
	
	self.bar:Disable()
	self:ToggleOptions()
end

function PetBarMod:ReassignBindings()
	if InCombatLockdown() then return end
	if not self.bar or not self.bar.buttons then return end
	ClearOverrideBindings(self.bar)
	for i = 1, 10 do
		local button, real_button = ("BONUSACTIONBUTTON%d"):format(i), ("BT4PetButton%d"):format(i)
		for k=1, select('#', GetBindingKey(button)) do
			local key = select(k, GetBindingKey(button))
			SetOverrideBindingClick(self.bar, false, key, real_button)
		end
	end
end

function PetBarMod:ApplyConfig()
	if not self:IsEnabled() then return end
	self.bar:ApplyConfig(self.db.profile)
	self:ReassignBindings()
end

PetBar.button_width = 30
PetBar.button_height = 30
function PetBar:OnEvent(event, arg1)
	if event == "PET_BAR_UPDATE" or 
		(event == "UNIT_PET" and arg1 == "player") or
		((event == "UNIT_FLAGS" or event == "UNIT_AURA") and arg1 == "pet") or
		event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED"
	then
		self:ForAll("Update")
	elseif event == "PET_BAR_UPDATE_COOLDOWN" then
		self:ForAll("UpdateCooldown")
	elseif event == "PET_BAR_SHOWGRID" then
		self:ForAll("ShowGrid")
	elseif event == "PET_BAR_HIDEGRID" then
		self:ForAll("HideGrid")
	end
end

function PetBar:ApplyConfig(config)
	ButtonBar.ApplyConfig(self, config)
	self:UpdateButtonLayout()
	self:ForAll("Update")
	self:ForAll("ApplyStyle", self.config.style)
end

function PetBar:Unlock()
	UnregisterUnitWatch(self)
	ButtonBar.Unlock(self)
end

function PetBar:Lock()
	ButtonBar.Lock(self)
	RegisterUnitWatch(self, false)
end
