-- TODO: scan the tooltip [Fawn] has been added to your pet journal!
--       says "Collected (2/3)"
--       what event is this?


local f = CreateFrame("Frame")


local function main()
  f:SetScript("OnEvent", function(self, event, ...) f[event](self, ...) end)
  f:RegisterEvent("PET_BATTLE_CAPTURED")
end


function f:PET_BATTLE_CAPTURED(...)
  self:RegisterEvent("CHAT_MSG_SYSTEM")
end


function f:CHAT_MSG_SYSTEM(msg, ...)
  -- This assumes the capture info is the *next* system message.
  self:UnregisterEvent("CHAT_MSG_SYSTEM")

  print(msg)

  -- the link is at the front
  local pattern = " has been added to your pet journal!"
  local pos = strfind(msg, pattern)
  if pos then
    local link = strsub(msg, 1, pos - 1)
    print(link)

    --[[
    -- http://wowprogramming.com/snippets/Scan_a_tooltip_15
    local tooltip = CreateFrame("GameTooltip", "JPetTooltip", UIParent,
                                "GameTooltipTemplate")
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    -- XXX it doesn't like this: "Unknown link type"
    tooltip:SetHyperlink(link)
    print(tooltip:NumLines())
    print(JPetTooltipTextLeft2:GetText())
    --]]

    -- Note this link is wrapped in a colorstring.
    -- http://wowprogramming.com/docs/api_types#colorString
    -- example:
    -- |cff0070dd|Hbattlepet:397:20:3:1192:218:231:0000000001838B0E|h[Skunk]|h
    -- speciesID, level, breedQuality, maxHealth, power, speed, battlePetID

    local _, speciesID = strsplit(":", link)
    print(speciesID)
    local owned = C_PetJournal.GetOwnedBattlePetString(speciesID)
    print(owned)
    -- Note this is *not* a number, but the string to be shown in the tooltip.
    -- Also wrapped in a colorstring.
    pos = owned:find("/") - 1
    local count = tonumber(owned:sub(pos, pos))
    print(count)
    if count == 3 then
      print("WARNING: You now have the maximum number of "..link)
    end
  end
end


main()
