local f = CreateFrame("Frame")


local function main()
  f:SetScript("OnEvent", f.Event)
  f:RegisterEvent("CHAT_MSG_PET_BATTLE_INFO")
  -- XXX I could, after this, register for chat messages and parse that
  f:RegisterEvent("COMPANION_LEARNED")
  f:RegisterEvent("PET_BATTLE_CAPTURED")
end


function f:Event(...)
  print(...)
  -- XXX
  --self:Scan()
end


-- scan through pets checking for any sets of three
function f:Scan()
  -- XXX is it possible to do this without messing with my filters?
  C_PetJournal.ClearSearchFilter()
  C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, true)
  C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, false)
  local _, numOwned = C_PetJournal.GetNumPets(true)

  local pets = { }

  for i = 1, numOwned do
    local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle = C_PetJournal.GetPetInfoByIndex(i)
    if isWildPet then
      pets[name] = 1 + (pets[name] or 0)
    end
  end

  for name, count in pairs(pets) do
    if count >= 3 then
      print(name)
    end
  end
end


main()
