local REVISION = 8;
if (type(LibGearExamCMOD) == "table") and (LibGearExamCMOD.revision and LibGearExamCMOD.revision >= REVISION) then
	return;
end

local _G = getfenv(0);

-- LibGearExam Table
LibGearExamCMOD = LibGearExamCMOD or {};
local LGE = LibGearExamCMOD;
LGE.revision = REVISION;

function AzMsg(msg) DEFAULT_CHAT_FRAME:AddMessage(tostring(msg):gsub("|1","|cffffff80"):gsub("|2","|cffffffff"),0.5,0.75,1.0); end
--[[
	Item Link Patterns -- Item strings have 11 parameters (5.1) and 14 in (WoD - 6.0.2)
		FORMAT  ->  item:itemId:enchantId:gemId1:gemId2:gemId3:gemId4:suffixId:uniqueId:linkLevel:reforgeId:upgradeId

	[Item links data change in 6.0, WoD]
		itemID:enchant:gem1:gem2:gem3:gem4:suffixID:uniqueID:level:reforgeId:upgradeId
		itemID:enchant:gem1:gem2:gem3:gem4:suffixID:uniqueID:level:upgradeId:instanceDifficultyID:numBonusIDs:bonusID1:bonusID2
	[ItemLinks in 6.2 -- Added: 10th param, specializationID]
		itemID:enchant:gem1:gem2:gem3:gem4:suffixID:uniqueID:level:specializationID:upgradeId:instanceDifficultyID:numBonusIDs:bonusID1:bonusID2
	[ItemLinks in 6.2.x -- Added: numBonusIDs? -- The number of bonus IDs are now dynamic, the 13th parameter tells how many there are -- Total Count (???): 14 + numBonusIDs (???)]
		itemID:enchant:gemID1:gemID2:gemID3:gemID4:suffixID:uniqueID:linkLevel:specializationID:upgradeTypeID:instanceDifficultyID:numBonusIDs:bonusID1:bonusID2:...:upgradeID
--]]

LGE.ITEMLINK_PATTERN			= "(item:[^|]+)";					-- Matches the raw itemLink from the full itemString
-- Pattern generation for itemLinks. Always match from the start of the itemLink, to ensure that any new properties added to itemLinks, wont break our patterns.
LGE.ITEMLINK_PATTERN_ID			= "item:"..("[^:]*:"):rep(0).."(%d*)";
LGE.ITEMLINK_PATTERN_ENCHANT	= "item:"..("[^:]*:"):rep(1).."(%d*)";
LGE.ITEMLINK_PATTERN_LEVEL		= "(item:"..("[^:]*:"):rep(8)..")(%d*)(.+)";		-- used in gsub, so the pattern must match the entire link, even future added properties

-- Other Patterns
LGE.ItemUseToken = "^"..ITEM_SPELL_TRIGGER_ONUSE.." ";
LGE.SetNamePattern = "^(.+) %((%d)/(%d)%)$";
LGE.SetBonusTokenActive = "^"..ITEM_SET_BONUS:gsub("%%s","");
LGE.SetBonusTokenInactive = "%((%d+)%) "..ITEM_SET_BONUS:gsub("%%s","");

-- Schools
LGE.MagicSchools = { "FIRE", "NATURE", "ARCANE", "FROST", "SHADOW", "HOLY" };

-- Gear Slots
LGE.Slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot",
	"HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot",
	"MainHandSlot", "SecondaryHandSlot", "RANGEDSLOT"
};
LGE.SlotIDs = {};
for _, slotName in ipairs(LGE.Slots) do
	LGE.SlotIDs[slotName] = GetInventorySlotInfo(slotName);
end

-- Absolute Stats, ie. they don't scale in percentages
LGE.ABSOLUTE_STATS = {
	MASTERY = true,
	EXPERTISE = true,
};

-- Scanner Tooltip
LGE.Tip = LGE.Tip or CreateFrame("GameTooltip","LibGearExamCMODTip",nil,"GameTooltipTemplate");
LGE.Tip:SetOwner(UIParent,"ANCHOR_NONE");

-- Stores names of scanned sets -- Used in ScanUnitItems
local scannedSetNames = {};

--------------------------------------------------------------------------------------------------------
--           Scan all items & set bonuses on given [unit] - Make sure the tables are reset            --
--------------------------------------------------------------------------------------------------------
function LGE:ScanUnitItems(unit,statTable,setTable,firstPass)
	if (not unit) or (not UnitExists(unit)) then
		return;
	end

	firstPass = firstPass or false

	-- Check all item slots
	for _, slotName in ipairs(self.Slots) do
		-- Set New Item Tip
		self.Tip:ClearLines();
		self.Tip:SetInventoryItem(unit,self.SlotIDs[slotName]);

		if (_G['CINSPECT_DEBUG_GE'] or _G['CINSPECT_DEBUG_ITEM_CHECK']) then
			local name, link = self.Tip:GetItem();
			link = link and link:match(self.ITEMLINK_PATTERN);
			AzMsg(format("===|1%s|r, |1%s|r, link = |1%s|r ===", slotName, tostring(name), tostring(link)));
		end;

		local lastSetName;
		local lastBonusCount = 1;
		local tipLineCounts = firstPass and 1 or self.Tip:NumLines()
		-- Check Lines -- Az: re-write this loop as two loops instead?
		for i = 2, tipLineCounts do
			local needScan, lineText = self:DoLineNeedScan(_G["LibGearExamCMODTipTextLeft"..i],true);

			if (_G['CINSPECT_DEBUG_GE']) then
				AzMsg(format(">> RT: -> <%s> =>> %s", (lineText and lineText:gsub("|", "||") or "_EMPTY_LINE_"), (needScan and "True" or "False")));
			end

			if (needScan) then
				-- We use "setMax" to check if the Line was a SetNamePattern (WTB continue statement in Lua)
				local setName, setCount, setMax;
				-- Set Header (Only run this if we haven't found a set on this item yet)
				if (not lastSetName) then
					setName, setCount, setMax = lineText:match(self.SetNamePattern);
					if (setMax) and (not setTable[setName]) then
						setTable[setName] = { count = tonumber(setCount), max = tonumber(setMax) };
						lastSetName = setName;
						-- sets quality
						if (not setTable[setName]['color']) then
							local _, link = self.Tip:GetItem();
							setTable[setName]['color'] = select(3, strfind(link or "","(|c%x+)|Hitem:.-|h|r")) or "|cffffffff"
						end
						--continue :(
					end
				end
				-- Check Line for Patterns if this Line was not a SetNamePattern
				if (not setMax) then
					if (lineText:find(self.SetBonusTokenActive)) then
						-- If this item is part of a set, that we haven't scanned the setbonuses of, do it now.
						if (lastSetName) and (not scannedSetNames[lastSetName]) then
							self:ScanLineForPatterns(lineText,statTable);
							setTable[lastSetName]["setBonus"..lastBonusCount] = lineText;	-- Az: remove this as cached entries now use the new ScanArmorSetBonuses() function to get set bonus stats
							lastBonusCount = (lastBonusCount + 1);
						end
					else
						self:ScanLineForPatterns(lineText,statTable);
					end
				end
			end
		end
		-- Mark this set as scanned
		if (lastSetName) then
			scannedSetNames[lastSetName] = true;
		end
	end
	-- Cleanup
	wipe(scannedSetNames);
end
--------------------------------------------------------------------------------------------------------
--                   Scans a single item - Stats are added to the [statTable] param                   --
--------------------------------------------------------------------------------------------------------
function LGE:ScanItemLink(itemLink,statTable)
	if (itemLink) then
		-- Set Link
		self.Tip:ClearLines();
		self.Tip:SetHyperlink(itemLink);
		-- Check Lines
		for i = 2, self.Tip:NumLines() do
			local needScan, lineText = self:DoLineNeedScan(_G["LibGearExamCMODTipTextLeft"..i],false);
			if (needScan) then
				self:ScanLineForPatterns(lineText,statTable);
			end
		end
	end
end
--------------------------------------------------------------------------------------------------------
--                         Checks if a Line Needs to be Scanned for Patterns                          --
--------------------------------------------------------------------------------------------------------
function LGE:DoLineNeedScan(tipLine,scanSetBonuses)
	-- Init Line
	local text = tipLine:GetText();
	if (_G['CINSPECT_DEBUG_GE']) then
		AzMsg(format("> TP: -> <%s>", text:gsub("|", "||")));
	end
	local color = text:match("^(|c%x%x%x%x%x%x%x%x)");		-- look for color code at the start of line
	text = text:gsub("|c%x%x%x%x%x%x%x%x",""):gsub(",",""):gsub("|r","");	-- remove all color coding, to simplify pattern matching
	local r, g, b = tipLine:GetTextColor();
	r, g, b = ceil(r * 255), ceil(g * 255), ceil(b * 255);	-- some lines don't use color codes, but store color in the text widget itself
	-- Always *Skip* Gray Lines
	if (r == 128 and g == 128 and b == 128) or (color == "|cff808080") then
		return false, text;
	-- Active Set Bonuses (Must be checked before green color check)
	elseif (not scanSetBonuses and text:find(self.SetBonusTokenActive)) then
		return false, text;
	-- Skip "Use:" lines, they are not a permanent stat, so don't include them
	elseif (text:find(self.ItemUseToken)) then
		return false, text;
	-- Always *Scan* Green Lines
	elseif (r == 0 and g == 255 and b == 0) or (color == "|cff00ff00") then
		return true, text;
	-- Should Match: Normal +Stat, Base Item Armor, Block Value on Shields
	elseif (text:find("^[+-]?%d+ [^%d]")) then
		return true, text;
	-- Set Names (Needed to Check Sets)
	elseif (scanSetBonuses and text:find(self.SetNamePattern)) then
		return true, text;
	end
	return;
end
--------------------------------------------------------------------------------------------------------
--                                 Checks a Single Line for Patterns                                  --
--------------------------------------------------------------------------------------------------------
function LGE:ScanLineForPatterns(text,statTable)
	if (_G['CINSPECT_DEBUG_GE']) then AzMsg(format(">>> T = |1%s|r",text)) end;
	for index, pattern in ipairs(self.Patterns) do
		local pos, _, value1, value2 = text:find(pattern.p);
		if (pos) and (value1 or pattern.v) then
			-- Pattern Debugging -> Find obsolete patterns put on alert
			if (_G['CINSPECT_DEBUG_GE']) then
				local _, link = self.Tip:GetItem();
				link = link:match(self.ITEMLINK_PATTERN);
				AzMsg(format(">>> pattern = |1%s|r", pattern.p));
			end
			-- Add to stat
			if (type(pattern.s) == "string") then
				statTable[pattern.s] = (statTable[pattern.s] or 0) + (value1 or pattern.v);
			elseif (type(pattern.s) == "table") then
				for statIndex, statName in ipairs(pattern.s) do
					if (type(pattern.v) == "table") then
						statTable[statName] = (statTable[statName] or 0) + (pattern.v[statIndex]);
					-- Az: This is a bit messy, only supports 2 now, needs to make it dynamic and support as many extra values as needed
					elseif (statIndex == 2) and (value2) then
						statTable[statName] = (statTable[statName] or 0) + (value2);
					else
						statTable[statName] = (statTable[statName] or 0) + (value1 or pattern.v);
					end
				end
			end
		end
	end
end