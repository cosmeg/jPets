local f = CreateFrame("Frame")


local function main()
  f:SetScript("OnEvent", f.PET_BATTLE_CAPTURED)
  f:RegisterEvent("PET_BATTLE_CAPTURED")
end


function f:PET_BATTLE_CAPTURED(...)
  print(...)
  self:Scan()
end


-- scan through pets checking for any sets of three
function f:Scan()
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
