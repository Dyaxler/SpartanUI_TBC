--[[ $Id: Prototype.lua 77829 2008-07-05 12:41:16Z nevcairiel $ ]]
local ButtonBar = Bartender4.ButtonBar.prototype
local ActionBar = setmetatable({}, {__index = ButtonBar})
Bartender4.ActionBar = ActionBar
local module = Bartender4:GetModule("ActionBars")

--[[===================================================================================
	ActionBar Prototype
===================================================================================]]--

local initialPosition
do 
	-- Sets the Bar to its initial Position in the Center of the Screen
	function initialPosition(bar)
		bar:ClearSetPoint("CENTER", 0, -250 + (bar.id-1) * 38)
		bar:SavePosition()
	end
end

-- Apply the specified config to the bar and refresh all settings
function ActionBar:ApplyConfig(config)
	ButtonBar.ApplyConfig(self, config)
	
	config = self.config
	if not config.position then initialPosition(self) end
	
	self:UpdateButtons()
	self:UpdateSelfCast(true)
	self:UpdateStates()
end

-- Update the number of buttons in our bar, creating new ones if necessary
function ActionBar:UpdateButtons(numbuttons)
	if numbuttons then
		self.config.buttons = min(numbuttons, 12)
	else
		numbuttons = min(self.config.buttons, 12)
	end
	
	local buttons = self.buttons or {}
	
	local updateBindings = (numbuttons > #buttons)
	-- create more buttons if needed
	for i = (#buttons+1), numbuttons do
		buttons[i] = Bartender4.Button:Create(i, self)
	end
	
	-- show active buttons
	for i = 1, numbuttons do
		buttons[i]:SetParent(self)
		buttons[i]:SetLevels()
		buttons[i]:Show()
		buttons[i]:UpdateAction(true)
	end
	
	-- hide inactive buttons
	for i = (numbuttons + 1), #buttons do
		buttons[i]:Hide()
		buttons[i]:SetParent(UIParent)
	end
	
	self.numbuttons = numbuttons
	self.buttons = buttons
	
	self:UpdateButtonLayout()
	self:SetGrid()
	if updateBindings and self.id == "1" then
		module:ReassignBindings()
	end
end

function ActionBar:SkinChanged(...)
	ButtonBar.SkinChanged(self, ...)
	self:ForAll("Update")
end

function ActionBar:SetShow(...)
	ButtonBar.SetShow(self, ...)
	self:UpdateStates()
end


--[[===================================================================================
	ActionBar Config Interface
===================================================================================]]--


-- get the current number of buttons
function ActionBar:GetButtons()
	return self.config.buttons
end

-- set the number of buttons and refresh layout
ActionBar.SetButtons = ActionBar.UpdateButtons

function ActionBar:GetEnabled()
	return true
end

function ActionBar:SetEnabled(state)
	if not state then
		module:DisableBar(self.id)
	end
end

function ActionBar:GetGrid()
	return self.config.showgrid
end

function ActionBar:SetGrid(state)
	if state ~= nil then
		self.config.showgrid = state
	end
	if self.config.showgrid then
		self:ForAll("ShowGrid", true)
	else
		self:ForAll("HideGrid", true)
	end
end

function ActionBar:SetHideMacroText(state)
	if state ~= nil then
		self.config.hidemacrotext = state
	end
	self:ForAll("Update")
end

function ActionBar:GetHideMacroText()
	return self.config.hidemacrotext
end

function ActionBar:SetHideHotkey(state)
	if state ~= nil then
		self.config.hidehotkey = state
	end
	self:ForAll("Update")
end

function ActionBar:GetHideHotkey()
	return self.config.hidehotkey
end

function ActionBar:UpdateSelfCast(nostates)
	self:ForAll("SetAttribute", "checkselfcast", Bartender4.db.profile.selfcastmodifier and true or nil)
	if not nostates then
		self:UpdateStates()
	end
end
