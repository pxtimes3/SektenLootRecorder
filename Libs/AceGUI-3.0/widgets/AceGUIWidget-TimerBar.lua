--[[-----------------------------------------------------------------------------
TimerBar Widget
Graphical Button.
-------------------------------------------------------------------------------]]
local Type, Version = "TimerBar", 24
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs = pairs

-- WoW APIs
local _G = _G
local CreateFrame, UIParent = CreateFrame, UIParent
local maximum, timer

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Control_OnEnter(frame)
	frame.obj:Fire("OnEnter")
end

local function Control_OnLeave(frame)
	frame.obj:Fire("OnLeave")
end

local function Control_OnEnd(frame)
	frame.obj:Fire("OnEnd")
end

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		-- restore default values
		self:SetHeight(24)
		self:SetWidth(200)

		self.frame:SetBackdrop({bgFile = [[Interface\ChatFrame\ChatFrameBackground]]})
		self.frame:SetBackdropColor(0, 0, 0, 0.7)
		self.frame:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		self.frame:SetStatusBarColor(0, 0, 1)
		self.frame:SetMinMaxValues(0,100)
		self.frame:SetValue(0)
		self.frame:Hide()
		maximum = 100
		timer = 0
	end,

	-- ["OnRelease"] = nil,

	["SetBackgroundTexture"] = function(self, texture)
		self.frame:SetBackdrop({bgFile = texture})
	end,

	["SetStatusBarTexture"] = function(self, texture)
		self.frame:SetStatusBarTexture(texture)
	end,

	["SetMaxValue"] = function(self, max)
		maximum = max
		self.frame:SetMinMaxValues(0, max)
	end,

	["Hide"] = function(self)
		self.frame:Hide()
	end,

	["Show"] = function(self)
		self.frame:Show()
	end,

	["Start"] = function(self)
		timer = 0
		self.frame:Show()
		self.frame:SetValue(maximum)
		self.frame:SetScript("OnUpdate", function(self, elapsed)
			timer = timer + elapsed
			self:SetValue(maximum-timer)
			-- when timer has reached the desired value, as defined by global END (seconds), restart it by setting it to 0, as defined by global START
			if timer >= maximum then
				self:SetScript("OnUpdate", nil)
				self:Hide()
				Control_OnEnd(self)
			end
		end)
	end,

	["Stop"] = function(self, hide)
		self.frame:Hide()
		self.frame:SetScript("OnUpdate", nil)
		self.frame:SetValue(0)
		timer = 0
	end


}

--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
local function Constructor()
	local name = "AceGUI30TimerBar" .. AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("StatusBar", name, UIParent)
	frame:Hide()

	frame:SetScript("OnEnter", Control_OnEnter)
	frame:SetScript("OnLeave", Control_OnLeave)

	local widget = {
		text  = text,
		frame = frame,
		type  = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsWidget(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
