--[[
	Generic Bar Frame Template
]]

--[[ $Id: Prototype.lua 79818 2008-08-05 16:39:53Z nevcairiel $ ]]
local Bar = CreateFrame("Button")
local Bar_MT = {__index = Bar}

local table_concat, table_insert = table.concat, table.insert

--[[===================================================================================
	Universal Bar Contructor
===================================================================================]]--

local defaults = {
	scale = 1,
	alpha = 1,
	fadeout = false,
	fadeoutalpha = 0.1,
	fadeoutdelay = 0.2,
	show = "alwaysshow",
}

local barOnEnter, barOnLeave, barOnDragStart, barOnDragStop, barOnClick, barOnUpdateFunc
do
	function barOnEnter(self)
		self:SetBackdropBorderColor(0.5, 0.5, 0, 1)
	end

	function barOnLeave(self)
		self:SetBackdropBorderColor(0, 0, 0, 0)
	end

	function barOnDragStart(self)
		local parent = self:GetParent()
		parent:StartMoving()
		self:SetBackdropBorderColor(0, 0, 0, 0)
		parent.isMoving = true
	end

	function barOnDragStop(self)
		local parent = self:GetParent()
		if parent.isMoving then
			parent:StopMovingOrSizing()
			parent:SavePosition()
		end
	end
	
	function barOnClick(self)
		-- TODO: Hide/Show bar on Click
		-- TODO: Once dropdown config is stable, show dropdown on rightclick
	end
	
	function barOnUpdateFunc(self, elapsed) 
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > self.config.fadeoutdelay then
			self:ControlFadeOut(self.elapsed)
			self.elapsed = 0
		end
	end
end

local barregistry = {}
Bartender4.Bar = {}
Bartender4.Bar.defaults = defaults
Bartender4.Bar.prototype = Bar
Bartender4.Bar.barregistry = barregistry
function Bartender4.Bar:Create(id, config, name)
	id = tostring(id)
	assert(not barregistry[id], "duplicated entry in barregistry.")
	
	local bar = setmetatable(CreateFrame("Frame", ("BT4Bar%s"):format(id), UIParent, "SecureStateHeaderTemplate"), Bar_MT)
	barregistry[id] = bar
	bar.id = id
	bar.name = name or id
	bar:SetMovable(true)
	
	local overlay = CreateFrame("Button", bar:GetName() .. "Overlay", bar)
	bar.overlay = overlay
	overlay:EnableMouse(true)
	overlay:RegisterForDrag("LeftButton")
	overlay:RegisterForClicks("LeftButtonUp")
	overlay:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 16,
		insets = {left = 5, right = 3, top = 3, bottom = 5}
	})
	overlay:SetBackdropColor(0, 0, 0, 0)
	overlay:SetBackdropBorderColor(0.5, 0.5, 0, 0)
	overlay.Text = overlay:CreateFontString(nil, "ARTWORK")
	overlay.Text:SetFontObject(GameFontNormal)
	overlay.Text:SetText(name)
	overlay.Text:Show()
	overlay.Text:ClearAllPoints()
	overlay.Text:SetPoint("CENTER", overlay, "CENTER")
	
	overlay:SetScript("OnEnter", barOnEnter)
	overlay:SetScript("OnLeave", barOnLeave)
	overlay:SetScript("OnDragStart", barOnDragStart)
	overlay:SetScript("OnDragStop", barOnDragStop)
	overlay:SetScript("OnClick", barOnClick)
	
	overlay:SetFrameLevel(bar:GetFrameLevel() + 10)
	overlay:ClearAllPoints()
	overlay:SetAllPoints(bar)
	overlay:Hide()
	
	bar.config = config
	bar.elapsed = 0
	bar.hidedriver = {}
	
	return bar
end

function Bartender4.Bar:GetAll()
	return pairs(barregistry)
end

function Bartender4.Bar:ForAll(method, ...)
	for _,bar in self:GetAll() do
		local func = bar[method]
		if func then
			func(bar, ...)
		end
	end
end

--[[===================================================================================
	Universal Bar Prototype
===================================================================================]]--

function Bar:ApplyConfig(config)
	if config then
		self.config = config
	end
	if self.disabled then return end
	self:InitVisibilityDriver()
	self:SetShow()
	self:Lock()
	self:LoadPosition()
	self:SetConfigScale()
	self:SetConfigAlpha()
	self:SetFadeOut()
	self:ApplyVisibilityDriver()
end

function Bar:Unlock()
	if self.disabled or self.unlocked then return end
	self.unlocked = true
	self:DisableVisibilityDriver()
	self:Show()
	self.overlay:Show()
	if self.config.show == "alwayshide" then
		self.overlay:SetBackdropColor(1, 0, 0, 0.5)
	else
		self.overlay:SetBackdropColor(0, 1, 0, 0.5)
	end
	if self.config.fadeout then
		self:SetScript("OnUpdate", nil)
		self.faded = nil
		self:SetConfigAlpha()
	end
end

function Bar:Lock()
	if self.disabled or not self.unlocked then return end
	self.unlocked = nil
	barOnDragStop(self.overlay)
	
	self:ApplyVisibilityDriver()
	
	self.overlay:Hide()
	
	self:SetFadeOut()
end

function Bar:LoadPosition()
	if not self.config.position then return end
	local pos = self.config.position
	local x, y, s = pos.x, pos.y, self:GetEffectiveScale()
	local point, relPoint = pos.point, pos.relPoint
	x, y = x/s, y/s
	self:ClearSetPoint(point, UIParent, relPoint, x, y)
end

function Bar:SavePosition()
	if not self.config.position then self.config.position = {} end
	local pos = self.config.position
	local point, parent, relPoint, x, y = self:GetPoint()
	local s = self:GetEffectiveScale()
	x, y = x*s, y*s
	pos.x, pos.y = x, y
	pos.point, pos.relPoint = point, relPoint
end

function Bar:SetSize(width, height)
	self:SetWidth(width)
	self:SetHeight(height or width)
end

function Bar:GetShow()
	return self.config.show
end

function Bar:SetShow(show)
	if show ~= nil then
		self.config.show = show
	end
	if not self.unlocked then
		self:InitVisibilityDriver()
		self:ApplyVisibilityDriver()
	else
		self:Show()
		self:InitVisibilityDriver()
		if self.config.show == "alwayshide" then
			self.overlay:SetBackdropColor(1, 0, 0, 0.5)
		else
			self.overlay:SetBackdropColor(0, 1, 0, 0.5)
		end
	end
end

function Bar:GetConfigAlpha()
	return self.config.alpha
end

function Bar:SetConfigAlpha(alpha)
	if alpha then
		self.config.alpha = alpha
	end
	if not self.faded then
		self:SetAlpha(self.config.alpha)
	end
end

function Bar:GetConfigScale()
	return self.config.scale
end

function Bar:SetConfigScale(scale)
	if scale then
		self.config.scale = scale
	end
	self:SetScale(self.config.scale)
	self:LoadPosition()
end

function Bar:GetFadeOut()
	return self.config.fadeout
end

function Bar:SetFadeOut(fadeout)
	if fadeout ~= nil then
		self.config.fadeout = fadeout
	end
	if self.config.fadeout then
		self:SetScript("OnUpdate", barOnUpdateFunc)
		self:ControlFadeOut()
	else
		self:SetScript("OnUpdate", nil)
		self.faded = nil
		self:SetConfigAlpha()
	end
end

function Bar:GetFadeOutAlpha()
	return self.config.fadeoutalpha
end

function Bar:SetFadeOutAlpha(fadealpha)
	if fadealpha ~= nil then
		self.config.fadeoutalpha = fadealpha
	end
	if self.faded then
		self:SetAlpha(self.config.fadeoutalpha)
	end
end

function Bar:GetFadeOutDelay()
	return self.config.fadeoutdelay
end

function Bar:SetFadeOutDelay(delay)
	if delay ~= nil then
		self.config.fadeoutdelay = delay
	end
end

function Bar:ControlFadeOut()
	if self.config.fadeout then
		if self.faded and MouseIsOver(self) then
			self:SetAlpha(self.config.alpha)
			self.faded = nil
		elseif not self.faded and not MouseIsOver(self) then
			self:SetAlpha(self.config.fadeoutalpha)
			self.faded = true
		end
	end
end


function Bar:InitVisibilityDriver()
	self.hidedriver = {}
	UnregisterStateDriver(self, 'visibility')
	if self.config.show == "alwaysshow" or self.config.show == true then
		--
	elseif self.config.show == "alwayshide" or self.config.show == false then
		self:RegisterVisibilityCondition("hide")
	elseif self.config.show == "combatshow" then
		self:RegisterVisibilityCondition("[nocombat]hide")
	elseif self.config.show == "combathide" then
		self:RegisterVisibilityCondition("[combat]hide")
	end
end

function Bar:RegisterVisibilityCondition(condition)
	table_insert(self.hidedriver, condition)
end

function Bar:ApplyVisibilityDriver()
	if self.unlocked then return end
	-- default state is shown
	self:RegisterVisibilityCondition("show")
	RegisterStateDriver(self, "visibility", table_concat(self.hidedriver, ";"))
end

function Bar:DisableVisibilityDriver()
	UnregisterStateDriver(self, "visibility")
	self:SetAttribute("state-visibility", nil)
	self:Show()
end

function Bar:Enable()
	if not self.disabled then return end
	self.disabled = nil
end

function Bar:Disable()
	if self.disabled then return end
	self.disabled = true
	self:UnregisterAllEvents()
	self:DisableVisibilityDriver()
	self:Hide()
end

--[[
	Lazyness functions
]]
function Bar:ClearSetPoint(...)
	self:ClearAllPoints()
	self:SetPoint(...)
end
