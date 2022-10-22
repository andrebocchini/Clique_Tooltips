local addonName, addon = ...

addon.NAME = addonName

local buttonNamesMap = {
	button1 = "Left Click",
	button2 = "Right Click",
	button3 = "Middle Click"
}

local function Clique_Tooltips_ButtonIndexString(modifier, number)
	local modifier = (modifier ~= nil and modifier ~= "") and (modifier .. "-") or ""
	return string.upper(modifier .. "BUTTON" .. number)
end

local function Clique_Tooltips_ButtonDisplayString(modifier, button)
	local displayModifier = modifier ~= nil and string.upper(modifier) or ""
	local displayButton = button ~= nil and buttonNamesMap[string.lower(button)]  or ""

	if string.len(displayModifier) > 0 then
		displayModifier = displayModifier .. "+"
	end
	return displayModifier .. displayButton
end

local function Clique_Tooltips_GetCliqueBindings(modifier)
	local cliqueBindings = Clique.bindings

	local button1 = Clique_Tooltips_ButtonIndexString(modifier, 1)
	local button2 = Clique_Tooltips_ButtonIndexString(modifier, 2)
	local button3 = Clique_Tooltips_ButtonIndexString(modifier, 3)

	local filteredBindings = {}

	for _, value in pairs(cliqueBindings) do
		local key = string.upper(value.key)
		local type = value.type
		local spell = value.spell ~= nil and value.spell or ""

		if key == button1 or key == button2 or key == button3 then
			if type == "spell" then
				filteredBindings[key] = spell
			elseif type == "target" then
				filteredBindings[key] = "Target"
			elseif type == "menu" then
				filteredBindings[key] = "Menu"
			elseif type == "macro" then
				filteredBindings[key] = "Macro"
			end
		end
	end

	return filteredBindings
end

local function Clique_Tooltips_ShouldUpdateTooltip(unit)
	return GameTooltip:IsUnit("player") or 
		GameTooltip:IsUnit("party1") or 
		GameTooltip:IsUnit("party2") or 
		GameTooltip:IsUnit("party3") or 
		GameTooltip:IsUnit("party4")
end

local function Clique_Tooltips_AddPlusSignToModifierIfNecessary(modifier)
	if string.len(modifier) > 0 then
		modifier = modifier .. "-"
	end

	return modifier
end

local function CliqueTooltips_BuildModifierBasedOnPressedKeys()
	local modifier = ""

	if IsAltKeyDown() then
		modifier = "ALT"
	end

	if IsControlKeyDown() then
		modifier = Clique_Tooltips_AddPlusSignToModifierIfNecessary(modifier)
		modifier = modifier .. "CTRL"
	end

	if IsShiftKeyDown() then
		modifier = Clique_Tooltips_AddPlusSignToModifierIfNecessary(modifier)
		modifier = modifier .. "SHIFT"
	end

	return modifier
end

-- Addon Init

GameTooltip:HookScript("OnShow", function(self)
	local _, unit = GameTooltip:GetUnit()

	if Clique_Tooltips_ShouldUpdateTooltip(unit) == false then
		return
	end

	local modifier = CliqueTooltips_BuildModifierBasedOnPressedKeys()

	local filteredBindings = Clique_Tooltips_GetCliqueBindings(modifier)

	local button1 = Clique_Tooltips_ButtonIndexString(modifier, 1)
	local button2 = Clique_Tooltips_ButtonIndexString(modifier, 2)
	local button3 = Clique_Tooltips_ButtonIndexString(modifier, 3)
	
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("Clique Bindings")
	GameTooltip:AddLine(" ")

	local displayButton1 = Clique_Tooltips_ButtonDisplayString(modifier, "button1")
	local displayButton2 = Clique_Tooltips_ButtonDisplayString(modifier, "button2")
	local displayButton3 = Clique_Tooltips_ButtonDisplayString(modifier, "button3")

	local notAssigned = "<not assigned>"

	local button1Binding = (filteredBindings[button1] ~= nil) and filteredBindings[button1] or notAssigned
	local button2Binding = (filteredBindings[button2] ~= nil) and filteredBindings[button2] or notAssigned
	local button3Binding = (filteredBindings[button3] ~= nil) and filteredBindings[button3] or notAssigned

	GameTooltip:AddLine("|c0000ff00" .. displayButton1.. ": |c00ffffff" .. button1Binding)
	GameTooltip:AddLine("|c0000ff00" .. displayButton2 .. ": |c00ffffff" .. button2Binding)
	GameTooltip:AddLine("|c0000ff00" .. displayButton3 .. ": |c00ffffff" .. button3Binding)
	
	GameTooltip:Show()
end)
