
------------------------------------------------
-- @DepandsOn: LibStub, LibEvent, LibItemStats
------------------------------------------------

local AS = unpack(AddOnSkins)

--STAT_RESISTANCE_ATTRIBUTES = GetStatsName("Resistance")
STAT_SUIT_ATTRIBUTES = "Suits"--GetStatsName("Suit")

--赋数据
local function SetStats(self, data)
    self.data = data or {}
    return self
end

--创建单条属性按钮框体
local function CreateStatFrame(parent, index, key, option)
    local frame = CreateFrame("Frame", nil, parent, "CharacterStatFrameTemplate")
    frame:EnableMouse(false)
    frame:SetWidth(198)
    --frame.key = key
    frame.Background:SetShown((index%2) ~= 1)
    parent["stat" .. index] = frame

    -- addon skin
    if (AS and MerInspectDB.EnableAddOnSkins) then
        --AS:SkinFrame(frame)
        frame.Background:Hide()
    end

    return frame
end


--获取可用的属性按钮框体
local function GetStatFrame(self)
    while (self["stat"..self.frameIdx]) do
        if (not self["stat"..self.frameIdx]:IsShown()) then
            local t = self["stat"..self.frameIdx]
            self.frameIdx = self.frameIdx + 1
            return t
        end
        self.frameIdx = self.frameIdx + 1
    end
    return CreateStatFrame(self, self.frameIdx)
end

local function DisplayRow(self, parent, row, idx)
    --local frame = CreateFrame("Frame", nil, parent, "CharacterStatFrameTemplate")
    local frame = GetStatFrame(self)
    frame.Label:SetText(row.t)
    frame.Value:SetText(row.v or "")

    -- set point
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -self.BannerH - (idx - 1)* 16)
    frame:Show()
end


function ClassicStatsFrameTemplate_Onload(self)
    self.backdrop = {
        bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile     = true,
        tileSize = 8,
        edgeSize = 16,
        insets   = {left = 4, right = 4, top = 4, bottom = 4}
    }
    self:SetBackdrop(self.backdrop)
    self:SetBackdropColor(0, 0, 0, 0.88)
    self.SetStats = SetStats
    self.BannerH = 40
    self.soffset = 0

    _G['CINSPECT_SFRAME_PTR'] = self

    -- stat Category frame
    for _, frame_key in ipairs({'AttributesCategory', 'TankCategory',
                                'MeleeCategory', 'SpellCategory',
                                'SuitCategory', 'TestCategory'}) do
        local frame = self[frame_key]
        frame.Background:SetAlpha(0.6)

        -- addon skin
        if (AS and MerInspectDB.EnableAddOnSkins) then
            AS:SkinFrame(frame)
            local font, _ = frame.Title:GetFont()
            frame.Title:SetFont(font, 15)
            frame:SetHeight(30)
        end
    end

    -- Addon Skins
    if (AS and MerInspectDB.EnableAddOnSkins) then
        AS:SkinFrame(self)
        self.BannerH = 34
        self.soffset = 8
    end
end

function ClassicStatsFrameTemplate_OnShow(self)
    local height = 5
    local tableN = 0
    self.frameIdx = 1

    -- display basic stats
    for idx, row in ipairs(self.data.BASIC) do
        DisplayRow(self, self.AttributesCategory, row, idx)
        tableN = tableN + 1
    end
    self.AttributesCategory:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -5)
    local offset = tableN * 16 + self.soffset
    local lastframe = self.AttributesCategory
    tableN = 0
    height = height + offset + self.BannerH

    -- display defense(TANK)
    if (self.data.DEFENSE) then
        for idx, row in ipairs(self.data.DEFENSE) do
            DisplayRow(self, self.TankCategory, row, idx)
            tableN = tableN + 1
        end

        self.TankCategory:Show()
        self.TankCategory:SetPoint("TOPLEFT", lastframe, "BOTTOMLEFT", 0, -offset)
        offset = tableN * 16 + self.soffset
        height = height + offset + self.BannerH
        lastframe = self.TankCategory
        tableN = 0
    end


    -- display Melee
    if (self.data.MELEE) then
        for idx, row in ipairs(self.data.MELEE) do
            DisplayRow(self, self.MeleeCategory, row, idx)
            tableN = tableN + 1
        end

        self.MeleeCategory:Show()
        self.MeleeCategory:SetPoint("TOPLEFT", lastframe, "BOTTOMLEFT", 0, -offset)
        offset = tableN * 16 + self.soffset
        height = height + offset + self.BannerH
        lastframe = self.MeleeCategory
        tableN = 0
    end

    -- display Spell
    if (self.data.SPELL) then
        for idx, row in ipairs(self.data.SPELL) do
            DisplayRow(self, self.SpellCategory, row, idx)
            tableN = tableN + 1
        end

        self.SpellCategory:Show()
        self.SpellCategory:SetPoint("TOPLEFT", lastframe, "BOTTOMLEFT", 0, -offset)
        offset = tableN * 16 + self.soffset
        height = height + offset + self.BannerH
        lastframe = self.SpellCategory
        tableN = 0
    end

    -- suits
    if (self.data.SuitsTable and next(self.data.SuitsTable)) ~= nil then
        idx = 1
        for name, data in pairs(self.data.SuitsTable) do
            local v = {['t'] = format("%s%s (%d/%d)|r",data.color, name, data.count, data.max)}
            DisplayRow(self, self.SuitCategory, v, idx)
            idx = idx + 1
        end

        self.SuitCategory:Show()
        self.SuitCategory:SetPoint("TOPLEFT", lastframe, "BOTTOMLEFT", 0, -offset)
        offset = (idx-1) * 16 + self.soffset
        height = height + offset + self.BannerH
        lastframe = self.SuitCategory
    end

    -- Test
    --if (1) then
    --    local test_cnt = 15
    --    for idx=1,test_cnt do
    --        DisplayRow(self, self.TestCategory, {['v']=idx, ['t']='Test'..idx}, idx)
    --        tableN = tableN + 1
    --    end

    --    self.TestCategory:Show()
    --    self.TestCategory:SetPoint("TOPLEFT", lastframe, "BOTTOMLEFT", 0, -offset)
    --    offset = tableN * 16 + self.soffset
    --    height = height + offset + self.BannerH
    --    lastframe = self.TestCategory
    --    tableN = 0
    --end

    -- set height
    self:SetHeight(math.max(height, 424))
    if (height <= 424) then
        self.parentScrollBar:Hide()
    else
        self.parentScrollBar:Show()
    end
end

function ClassicStatsFrameTemplate_OnHide(self)
    local index = 1
    while (self["stat"..index]) do
        self["stat"..index].Label:SetText("")
        self["stat"..index].Value:SetText("")
        self["stat"..index]:Hide()
        index = index + 1
    end
    self.TankCategory:ClearAllPoints()
    self.TankCategory:Hide()
    self.MeleeCategory:ClearAllPoints()
    self.MeleeCategory:Hide()
    self.SpellCategory:ClearAllPoints()
    self.SpellCategory:Hide()
    self.SuitCategory:ClearAllPoints()
    self.SuitCategory:Hide()
end
