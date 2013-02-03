local f = CreateFrame("Frame")


local function main()
  f:SetScript("OnEvent", function(self, event, ...) f[event](self, ...) end)
  f:RegisterEvent("PET_BATTLE_CAPTURED")

  -- This is not needed every time as long as you pay attention to the
  -- after-capture warnings.
  --f:FullScan()
end


function f:PET_BATTLE_CAPTURED(...)
  self:RegisterEvent("CHAT_MSG_SYSTEM")
end


function f:CHAT_MSG_SYSTEM(msg, ...)
  -- the link is at the front
  local pattern = " has been added to your pet journal!"
  local pos = strfind(msg, pattern)
  if not pos then return end

  self:UnregisterEvent("CHAT_MSG_SYSTEM")  -- we've found what we're looking for

  -- Note this link is wrapped in a colorstring (but doesn't really matter).
  -- http://wowprogramming.com/docs/api_types#colorString
  -- example:
  -- |cff0070dd|Hbattlepet:397:20:3:1192:218:231:0000000001838B0E|h[Skunk]|h
  -- speciesID, level, breedQuality, maxHealth, power, speed, battlePetID
  local link = strsub(msg, 1, pos - 1)
  local _, speciesID = strsplit(":", link)

  -- Note this is *not* a number, but the string to be shown in the tooltip.
  -- Also wrapped in a colorstring.
  local owned = C_PetJournal.GetOwnedBattlePetString(speciesID)
  pos = owned:find("/") - 1
  local count = tonumber(owned:sub(pos, pos))
  if count == 3 then
    print("WARNING: You now have the maximum number of "..link)
  end
end


function f:FullScan()
  local _, num = C_PetJournal.GetNumPets(true)
  print(num)
  for i = 1, num do
    local _, speciesID, _, _, _, _, _, speciesName = C_PetJournal.GetPetInfoByIndex(i, false)
    local owned = C_PetJournal.GetOwnedBattlePetString(speciesID)
    pos = owned:find("/") - 1
    local count = tonumber(owned:sub(pos, pos))
    if count >= 3 then
      print("WARNING: You have the maximum number of "..speciesName)
    end
  end
end


-- make local (method)
-- /run JMovePetBattleFrame()
-- /dump PetBattleFrame:GetPoint(1)
function JMovePetBattleFrame()
  local pbf = PetBattleFrame.BottomFrame
  -- I'm not sure why there are 2 points here.
  local point, relativeTo, relativePoint, xOffset, yOffset = pbf:GetPoint(1)
  pbf:ClearAllPoints()
  -- this isn't working. is it because of the "FrameLock"?
  -- actually, it could be because the PetBattleFrame takes up the entire
  -- screen...
  -- /dump PetBattleFrame:GetWidth() => 1480
  -- I think this is the case
  pbf:SetPoint(point, relativeTo, relativePoint, xOffset + 200, yOffset)
  -- is there a sub-frame? possibly un-named
  -- /dump GetChildrenTree(PetBattleFrame, 0)
  -- there's a LOT of shit here
  -- I think the best bet now is to look at the code:
  -- http://wowprogramming.com/utils/xmlbrowser/test/AddOns/Blizzard_PetBattleUI/Blizzard_PetBattleUI.lua
  -- /dump GetChildrenTree(PetBattleFrame.BottomFrame, 0)
  -- /dump GetChildrenTree(PetBattleFrame.BottomFrame.FlowFrame, 0)
end


main()
