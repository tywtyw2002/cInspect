-- Class Spec Icon from Details
local spec_icon_path = [[Interface\AddOns\MerInspect\texture\spec_icons_normal_alpha]]
local class_specs_coords = {
    [577] = {128/512, 192/512, 256/512, 320/512}, --> havoc demon hunter
    [581] = {192/512, 256/512, 256/512, 320/512}, --> vengeance demon hunter

    [250] = {0, 64/512, 0, 64/512}, --> blood dk
    [251] = {64/512, 128/512, 0, 64/512}, --> frost dk
    [252] = {128/512, 192/512, 0, 64/512}, --> unholy dk

    [102] = {192/512, 256/512, 0, 64/512}, -->  druid balance
    [103] = {256/512, 320/512, 0, 64/512}, -->  druid feral
    [104] = {320/512, 384/512, 0, 64/512}, -->  druid guardian
    [105] = {384/512, 448/512, 0, 64/512}, -->  druid resto

    [253] = {448/512, 512/512, 0, 64/512}, -->  hunter bm
    [254] = {0, 64/512, 64/512, 128/512}, --> hunter marks
    [255] = {64/512, 128/512, 64/512, 128/512}, --> hunter survivor

    [62] = {(128/512) + 0.001953125, 192/512, 64/512, 128/512}, --> mage arcane
    [63] = {192/512, 256/512, 64/512, 128/512}, --> mage fire
    [64] = {256/512, 320/512, 64/512, 128/512}, --> mage frost

    [268] = {320/512, 384/512, 64/512, 128/512}, --> monk bm
    [269] = {448/512, 512/512, 64/512, 128/512}, --> monk ww
    [270] = {384/512, 448/512, 64/512, 128/512}, --> monk mw

    [65] = {0, 64/512, 128/512, 192/512}, --> paladin holy
    [66] = {64/512, 128/512, 128/512, 192/512}, --> paladin protect
    [70] = {(128/512) + 0.001953125, 192/512, 128/512, 192/512}, --> paladin ret

    [256] = {192/512, 256/512, 128/512, 192/512}, --> priest disc
    [257] = {256/512, 320/512, 128/512, 192/512}, --> priest holy
    [258] = {(320/512) + (0.001953125 * 4), 384/512, 128/512, 192/512}, --> priest shadow

    [259] = {384/512, 448/512, 128/512, 192/512}, --> rogue assassination
    [260] = {448/512, 512/512, 128/512, 192/512}, --> rogue combat
    [261] = {0, 64/512, 192/512, 256/512}, --> rogue sub

    [262] = {64/512, 128/512, 192/512, 256/512}, --> shaman elemental
    [263] = {128/512, 192/512, 192/512, 256/512}, --> shamel enhancement
    [264] = {192/512, 256/512, 192/512, 256/512}, --> shaman resto

    [265] = {256/512, 320/512, 192/512, 256/512}, --> warlock aff
    [266] = {320/512, 384/512, 192/512, 256/512}, --> warlock demo
    [267] = {384/512, 448/512, 192/512, 256/512}, --> warlock destro

    [71] = {448/512, 512/512, 192/512, 256/512}, --> warrior arms
    [72] = {0, 64/512, 256/512, 320/512}, --> warrior fury
    [73] = {64/512, 128/512, 256/512, 320/512}, --> warrior protect
}


local function GetSpecIcon(spec)
    return spec_icon_path, class_specs_coords[spec]
end


hooksecurefunc("ShowInspectItemListFrame", function(unit, parent, itemLevel, maxLevel, spec)
    local frame = parent.inspectFrame
    if (not frame) then return end
    if (not frame.specframe) then
        --frame.specicon = frame:CreateTexture(nil, "BORDER")
        local icon_frame = CreateFrame("Frame", nil, frame)
        frame.specframe = icon_frame
        icon_frame.specicon = icon_frame:CreateTexture(nil, "BORDER")
        icon_frame.specicon:SetSize(42, 42)
        icon_frame.specicon:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -11)
        icon_frame.specicon:SetAlpha(0.6)
        --frame.specicon:SetMask("Interface\\Minimap\\UI-Minimap-Background")
        --frame.specicon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        icon_frame.spectext = icon_frame:CreateFontString(nil, "BORDER")
        icon_frame.spectext:SetFont(SystemFont_Outline:GetFont(), 13, "OUTLINE")
        icon_frame.spectext:SetPoint("BOTTOM", icon_frame.specicon, "BOTTOM")
        icon_frame.spectext:SetTextColor(1, 0.5, 0.25, 1.0);
        icon_frame.spectext:SetJustifyH("CENTER")
        icon_frame.spectext:SetAlpha(0.8)
        icon_frame.talenttext = icon_frame:CreateFontString(nil, "BORDER")
        icon_frame.talenttext:SetFont(SystemFont_Outline_Small:GetFont(), 11, "THINOUTLINE")
        icon_frame.talenttext:SetPoint("TOP", icon_frame.spectext, "BOTTOM")
        icon_frame.talenttext:SetJustifyH("CENTER")
        icon_frame.talenttext:SetAlpha(0.8)
    end

    if spec.id then
        local specIcon, specCoord = GetSpecIcon(spec.id)

        frame.specframe.specicon:SetTexture(specIcon)
        frame.specframe.specicon:SetTexCoord(unpack(specCoord))
        frame.specframe.spectext:SetText(spec.name)
        frame.specframe.talenttext:SetText(spec.talent)
    else
        local class = select(2, UnitClass(unit))
        frame.specframe.specicon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
        frame.specframe.specicon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[strupper(class)]))
    end
end)

