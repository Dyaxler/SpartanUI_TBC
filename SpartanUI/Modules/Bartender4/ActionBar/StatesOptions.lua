--[[ $Id: StatesOptions.lua 77829 2008-07-05 12:41:16Z nevcairiel $ ]]
local L = LibStub("AceLocale-3.0"):GetLocale("Bartender4")
local ActionBar = Bartender4.ActionBar

local module = Bartender4:GetModule("ActionBars")

local optGetter, optSetter
do
	local getBar, optionMap, callFunc
	
	optionMap = {
		stance = "StanceStateOption",
		enabled = "StateOption",
		def_state = "DefaultState",
		states = "StateOption",
		actionbar = "StateOption",
		possess = "StateOption",
		autoassist = "ConfigAutoAssist",
	}
	-- retrieves a valid bar object from the modules actionbars table
	function getBar(id)
		local bar = module.actionbars[tonumber(id)]
		assert(bar, "Invalid bar id in options table.")
		return bar
	end
	
	-- calls a function on the bar
	function callFunc(bar, type, option, ...)
		local func = type .. (optionMap[option] or option)
		assert(bar[func], "Invalid get/set function."..func)
		return bar[func](bar, ...)
	end
	
	-- universal function to get a option
	function optGetter(info)
		local bar = getBar(info[2])
		local option = info.arg or info[#info]
		return callFunc(bar, "Get", option, info[#info])
	end
	
	-- universal function to set a option
	function optSetter(info, ...)
		local bar = getBar(info[2])
		local option = info.arg or info[#info]
		return callFunc(bar, "Set", option, info[#info], ...)
	end
end


local hasStances

local validStanceTable = { 
	[-1] = "Hide", 
	[0] = "Don't Page", 
	("Page %2d"):format(1),
	("Page %2d"):format(2), 
	("Page %2d"):format(3), 
	("Page %2d"):format(4), 
	("Page %2d"):format(5), 
	("Page %2d"):format(6), 
	("Page %2d"):format(7), 
	("Page %2d"):format(8),
	("Page %2d"):format(9), 
	("Page %2d"):format(10) 
}


local _, playerclass = UnitClass("player")

local function createOptionGroup(k, id)
	local tbl = {
		order = 10 * k,
		type = "select",
		arg = "stance",
		values = validStanceTable,
		name = module.DefaultStanceMap[playerclass][k].name,
	}
	return tbl
end

local disabledFunc = function(info)
	local bar = module.actionbars[tonumber(info[2])]
	return not bar:GetStateOption("enabled")
end

function module:GetStateOptionsTable()
	local options = {
		enabled = {
			order = 1,
			type = "toggle",
			name = L["Enabled"],
			desc = L["Enable State-based Button Swaping"],
			get = optGetter,
			set = optSetter,
		},
		sep1 = {
			order = 2,
			type = "description",
			name = "",
		},
		actionbar = {
			order = 5,
			type = "toggle",
			name = L["ActionBar Switching"],
			desc = L["Enable Bar Switching based on the actionbar controls provided by the game."],
			get = optGetter,
			set = optSetter,
		},
		possess = {
			order = 5,
			type = "toggle",
			name = L["Possess Bar"],
			desc = L["Switch this bar to the Possess Bar when possessing a npc (eg. Mind Control)"],
			get = optGetter,
			set = optSetter,
			width = "half",
		},
		autoassist = {
			order = 6,
			type = "toggle",
			name = L["Auto-Assist"],
			desc = L["Enable Auto-Assist for this bar.\n Auto-Assist will automatically try to cast on your target's target if your target is no valid target for the selected spell."],
			get = optGetter,
			set = optSetter,
			width = "half",
		},
		def_desc = {
			order = 10,
			type = "description",
			name = L["The default behaviour of this bar when no state-based paging option affects it."],
		},
		def_state = {
			order = 11,
			type = "select",
			name = L["Default Bar State"],
			values = validStanceTable,
			get = optGetter,
			set = optSetter,
			disabled = disabledFunc,
		},
		modifiers = {
			order = 30,
			type = "group",
			inline = true,
			name = "",
			get = optGetter,
			set = optSetter,
			disabled = disabledFunc,
			args = {
				header = {
					order = 1,
					type = "header",
					name = L["Modifier Based Switching"],
				},
				ctrl = {
					order = 10,
					type = "select",
					name = L["CTRL"],
					arg = "states",
					values = validStanceTable,
					desc = (L["Configure actionbar paging when the %s key is down."]):format(L["CTRL"]),
					--width = "half",
				},
				alt = {
					order = 15,
					type = "select",
					name = L["ALT"],
					arg = "states",
					values = validStanceTable,
					desc = (L["Configure actionbar paging when the %s key is down."]):format(L["ALT"]),
					--width = "half",
				},
				shift = {
					order = 20,
					type = "select",
					name = L["SHIFT"],
					arg = "states",
					values = validStanceTable,
					desc = (L["Configure actionbar paging when the %s key is down."]):format(L["SHIFT"]),
					--width = "half",
				},
			},
		},
		stances = {
			order = 20,
			type = "group",
			inline = true,
			name = "",
			hidden = function() return not (module.DefaultStanceMap[playerclass]) end,
			get = optGetter,
			set = optSetter,
			disabled = disabledFunc,
			args = {
				stance_header = {
					order = 1,
					type = "header",
					name = L["Stance Configuration"],
				},
			},
		},
	}
	
	do
		local defstancemap = self.DefaultStanceMap[playerclass]
		if defstancemap then
			for k,v in pairs(defstancemap) do
				if not options.stances.args[v.id] then
					options.stances.args[v.id] = createOptionGroup(k, v.id)
				end
			end
		end
	end
	
	return options
end
