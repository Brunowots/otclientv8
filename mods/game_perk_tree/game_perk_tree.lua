
gamePerksMainButton = nil
foodeaterWindow = nil
perkTreeSys = {}
function init()
    ProtocolGame.registerExtendedOpcode(14, onExtendedOpcode)

    gamePerksMainButton = modules.client_topmenu.addRightToggleButton('gamePerksMainButton', tr('Game Perks Tree'), '/game_perk_tree/ui/icon', closing, false, 1)
    gamePerksMainButton:setOn(false)

    foodeaterWindow = g_ui.displayUI('game_perk_tree')
    foodeaterWindow:setVisible(false)

    --get help values
    allTabs = foodeaterWindow:recursiveGetChildById('allTabs')
    allTabs:setContentWidget(foodeaterWindow:getChildById('optionsTabContent'))

    gamePerksMainButton.onClick = function() setup() end
    perkTreeSys:setButtonDescriptions()

    -- if not g_game.isOnline() then
    --   gamePerksMainButton:hide()
    --   scheduleEvent(checkOnline, 10)
    -- end
end

function checkOnline()
  if g_game.isOnline() then
    gamePerksMainButton:show()
    scheduleEvent(checkOnline, 10)
  else
    gamePerksMainButton:hide()
    scheduleEvent(checkOnline, 10)
  end
end

function setup()
  if g_game.isOnline() then
    local protocolGame = g_game.getProtocolGame()
    local response = ""
    local data = {
        action = "getPlayerData",
    }
    if protocolGame then
      response = protocolGame:sendExtendedOpcode(14, json.encode(data))
      print(response)
    end

  end
end

function terminate()
  ProtocolGame.unregisterExtendedOpcode(14, onExtendedOpcode)
  gamePerksMainButton:destroy()
  foodeaterWindow:destroy()
end

function closing()
  if gamePerksMainButton:isOn() then
    foodeaterWindow:setVisible(false)
    gamePerksMainButton:setOn(false)
  else
    foodeaterWindow:setVisible(true)
    gamePerksMainButton:setOn(true)
  end
end

function perkTreeSys:setButtonDescriptions()
    healthButton = foodeaterWindow:getChildById('HealthButton')
    healthButton:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
    healthButtonFirstStageMax = foodeaterWindow:getChildById('HealthButtonFirstStageMax')
    healthButtonFirstStageMax:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
    healthButtonSecond = foodeaterWindow:getChildById('HealthButtonSecond')
    healthButtonSecond:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
    healthButtonSecondStageMax = foodeaterWindow:getChildById('HealthButtonSecondStageMax')
    healthButtonSecondStageMax:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")

    manaButton = foodeaterWindow:getChildById('ManaButton')
    manaButton:setTooltip("Add Mana: \n Knight +1 mp \n Paladin +3 mp \n Sorcerer/Driud +6 mp")
    manaButtonFirstStageMax = foodeaterWindow:getChildById('ManaButtonFirstStageMax')
    manaButtonFirstStageMax:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
    manaButtonSecond = foodeaterWindow:getChildById('ManaButtonSecond')
    manaButtonSecond:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
    manaButtonSecondStageMax = foodeaterWindow:getChildById('ManaButtonSecondStageMax')
    manaButtonSecondStageMax:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
    manaButton = foodeaterWindow:getChildById('CapButton')

    capButton = foodeaterWindow:getChildById('CapButton')
    capButton:setTooltip("Add Capacity: \n Knight +5 cap \n Paladin +4 cap \n Sorcerer/Driud +2 cap")
    capButtonFirstStageMax = foodeaterWindow:getChildById('CapButtonFirstStageMax')
    capButtonFirstStageMax:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
    capButtonSecond = foodeaterWindow:getChildById('CapButtonSecond')
    capButtonSecond:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
    capButtonSecondStageMax = foodeaterWindow:getChildById('CapButtonSecondStageMax')
    capButtonSecondStageMax:setTooltip("Add Healith: \n Knight +3 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")
end

    
function onExtendedOpcode(protocol, code, buffer)
    local json_status, json_data =
    pcall(
    function()
        return json.decode(buffer)
    end
    )

    if not json_status then
    g_logger.error("[My Module] JSON error: " .. json_data)
    return false
    end

    print_r(json_data)

    if json_data.action == "addHealth" then
        perkTreeSys:setHealthBtnPointsFirstStage(json_data.playerHealthPointsStageFirst, json_data.healthMaxPointsFirstStage)
        perkTreeSys:setHealthBtnPointsSecondStage(json_data.playerHealthPointsStageSecond, json_data.healthMaxPointsSecondStage)
    elseif json_data.action == "addMana" then
        perkTreeSys:setManaBtnPointsFirstStage(json_data.playerManaPointsStageFirst, json_data.manaMaxPointsFirstStage)
        perkTreeSys:setManaBtnPointsSecondStage(json_data.playerManaPointsStageSecond, json_data.manaMaxPointsSecondStage)
    elseif json_data.action == "addCap" then
        perkTreeSys:setCapBtnPointsFirstStage(json_data.playerCapPointsStageFirst, json_data.capMaxPointsFirstStage)
        perkTreeSys:setCapBtnPointsSecondStage(json_data.playerCapPointsStageSecond, json_data.capMaxPointsSecondStage)
    elseif json_data.action == "getPlayerData" then
        print("getPlayerData")
        perkTreeSys:setHealthBtnPointsFirstStage(json_data.playerHealthPointsStageFirst, json_data.healthMaxPointsFirstStage)
        perkTreeSys:setHealthBtnPointsSecondStage(json_data.playerHealthPointsStageSecond, json_data.healthMaxPointsSecondStage)
        perkTreeSys:setManaBtnPointsFirstStage(json_data.playerManaPointsStageFirst, json_data.manaMaxPointsFirstStage)
        perkTreeSys:setManaBtnPointsSecondStage(json_data.playerManaPointsStageSecond, json_data.manaMaxPointsSecondStage)
        perkTreeSys:setCapBtnPointsFirstStage(json_data.playerCapPointsStageFirst, json_data.capMaxPointsFirstStage)
        perkTreeSys:setCapBtnPointsSecondStage(json_data.playerCapPointsStageSecond, json_data.capMaxPointsSecondStage)
        perkTreeSys:setPoints(json_data.availablePoints, json_data.maxPoints)
        perkTreeSys:setupSkillTreeOverlayForVocation(json_data.vocation)
    end
end

function perkTreeSys:setPoints(availablePoints, maxPoints)
  pointsLabel = foodeaterWindow:getChildById('pointsLabel')
  pointsLabel:setText(tr("Points:") .. " " .. availablePoints .. "/" .. maxPoints)
end

function perkTreeSys:setHealthBtnPointsFirstStage(addedPoints, maxPoints)
    healthBtnFirstStage = foodeaterWindow:getChildById('HealthButton')
    healthBtnFirstStage:setText(tr("Health (+)") .. " " .. addedPoints .. "/" .. maxPoints)
end

function perkTreeSys:setHealthBtnPointsSecondStage(addedPoints, maxPoints)
    healthBtnSecondStage = foodeaterWindow:getChildById('HealthButtonSecond')
    healthBtnSecondStage:setText(tr("Health (+)") .. " " .. addedPoints .. "/" .. maxPoints)
end

function perkTreeSys:setManaBtnPointsFirstStage(addedPoints, maxPoints)
    manaBtnFirstStage = foodeaterWindow:getChildById('ManaButton')
    manaBtnFirstStage:setText(tr("Mana (+)") .. " " .. addedPoints .. "/" .. maxPoints)
end

function perkTreeSys:setManaBtnPointsSecondStage(addedPoints, maxPoints)
    manaBtnSecondStage = foodeaterWindow:getChildById('ManaButtonSecond')
    manaBtnSecondStage:setText(tr("Mana (+)") .. " " .. addedPoints .. "/" .. maxPoints)
end

function perkTreeSys:setCapBtnPointsFirstStage(addedPoints, maxPoints)
    capBtnFirstStage = foodeaterWindow:getChildById('CapButton')
    capBtnFirstStage:setText(tr("Capacity (+)") .. " " .. addedPoints .. "/" .. maxPoints)
end

function perkTreeSys:setCapBtnPointsSecondStage(addedPoints, maxPoints)
    capBtnSecondStage = foodeaterWindow:getChildById('CapButtonSecond')
    capBtnSecondStage:setText(tr("Capacity (+)") .. " " .. addedPoints .. "/" .. maxPoints)
end

function perkTreeSys:setupSkillTreeOverlayForVocation(vocId)
    if vocId == 1 then --sorcerer
        healthFirstStageFirstPerk = foodeaterWindow:getChildById('healthFirstStageFirstPerk')
        healthFirstStageFirstPerk:setVisible(true)
        -- healthFirstStageFirstPerk:setMarginLeft(100)
        healthFirstStageFirstPerk:setImageSource('/game_perk_tree/ui/ultimate_healing')
        healthFirstStageFirstPerk:setTooltip("Ultimate healing heals 20% more")
        healthFirstStageSecondPerk = foodeaterWindow:getChildById('healthFirstStageSecondPerk')
        healthFirstStageSecondPerk:setVisible(true)
        healthFirstStageSecondPerk:setImageSource('/game_perk_tree/ui/ultimate_healing')
        healthFirstStageSecondPerk:setTooltip("Ultimate healing cost 10 less mana")
        healthSecondStageFirstPerk = foodeaterWindow:getChildById('healthSecondStageFirstPerk')
        healthSecondStageFirstPerk:setVisible(true)
        healthSecondStageFirstPerk:setImageSource('/game_perk_tree/ui/ultimate_healing_rune')
        healthSecondStageFirstPerk:setTooltip("Increase ultimate healing rune healing by 20%")
        healthSecondStageSecondPerk = foodeaterWindow:getChildById('healthSecondStageSecondPerk')
        healthSecondStageSecondPerk:setVisible(true)
        healthSecondStageSecondPerk:setImageSource('/game_perk_tree/ui/health_icon')
        healthSecondStageSecondPerk:setTooltip("+50 hp")

        manaFirstStageFirstPerk = foodeaterWindow:getChildById('manaFirstStageFirstPerk')
        manaFirstStageFirstPerk:setVisible(true)
        manaFirstStageFirstPerk:setImageSource('/game_perk_tree/ui/mana_regen')
        manaFirstStageFirstPerk:setTooltip("Increase mana regen")
        manaFirstStageSecondPerk = foodeaterWindow:getChildById('manaFirstStageSecondPerk')
        manaFirstStageSecondPerk:setVisible(true)
        manaFirstStageSecondPerk:setImageSource('/game_perk_tree/ui/magic_level')
        manaFirstStageSecondPerk:setTooltip("Increase magic level +3")
        manaSecondStageFirstPerk = foodeaterWindow:getChildById('manaSecondStageFirstPerk')
        manaSecondStageFirstPerk:setVisible(true)
        manaSecondStageFirstPerk:setImageSource('/game_perk_tree/ui/energy_wave')
        manaSecondStageFirstPerk:setTooltip("Increase Energy Wave damage by 15%")
        manaSecondStageSecondPerk = foodeaterWindow:getChildById('manaSecondStageSecondPerk')
        manaSecondStageSecondPerk:setVisible(true)
        manaSecondStageSecondPerk:setImageSource('/game_perk_tree/ui/great_energy_beam')
        manaSecondStageSecondPerk:setTooltip("Increase Great Energy Beam damage by 20%")

        capFirstStageFirstPerk = foodeaterWindow:getChildById('capFirstStageFirstPerk')
        capFirstStageFirstPerk:setVisible(true)
        capFirstStageFirstPerk:setImageSource('/game_perk_tree/ui/haste')
        capFirstStageFirstPerk:setTooltip("Increase movement speed +15")
        capFirstStageSecondPerk = foodeaterWindow:getChildById('capFirstStageSecondPerk')
        capFirstStageSecondPerk:setVisible(true)
        capFirstStageSecondPerk:setImageSource('/game_perk_tree/ui/mana_potion')
        capFirstStageSecondPerk:setTooltip("Increase mana gains by mana fluid +5")
        capSecondStageFirstPerk = foodeaterWindow:getChildById('capSecondStageFirstPerk')
        capSecondStageFirstPerk:setVisible(true)
        capSecondStageFirstPerk:setImageSource('/game_perk_tree/ui/magic_level')
        capSecondStageFirstPerk:setTooltip("+4 magic levels")
        capSecondStageSecondPerk = foodeaterWindow:getChildById('capSecondStageSecondPerk')
        capSecondStageSecondPerk:setVisible(true)
        capSecondStageSecondPerk:setImageSource('/game_perk_tree/ui/mana_potion')
        capSecondStageSecondPerk:setTooltip("Increase mana gains by mana fluid +5")

    elseif vocId == 2 then -- druid
    elseif vocId == 3 then -- paladin
    elseif vocId == 4 then --knight
    end
end

function HealthButton()
    local protocolGame = g_game.getProtocolGame()
    if gamePerksMainButton:isOn() then
    if protocolGame then
        local data = {
            action = "addHealth",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
        end
    else
        foodeaterWindow:setVisible(true)
        gamePerksMainButton:setOn(true)
    end
end

function HealthButtonFirstStageMax()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "addHealthFirstStageMax",
            value = 30
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function HealthButtonSecondStageMax()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
        action = "addHealthSecondStageMax",
        value = 90
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function HealthFirstStageFirstPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setHealthFirstStageFirstPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function HealthFirstStageSecondPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setHealthFirstStageSecondPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function HealthSecondStageFirstPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setHealthSecondStageFirstPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function HealthSecondStageSecondPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setHealthSecondStageSecondPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function ManaButton()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "addMana",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function ManaButtonFirstStageMax()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "addManaFirstStageMax",
            value = 30
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function ManaButtonSecondStageMax()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
        action = "addManaSecondStageMax",
        value = 90
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function ManaFirstStageFirstPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setManaFirstStageFirstPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function ManaFirstStageSecondPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setManaFirstStageSecondPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function ManaSecondStageFirstPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setManaSecondStageFirstPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function ManaSecondStageSecondPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setManaSecondStageSecondPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function CapButton()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "addCap",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function CapButtonFirstStageMax()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "addCapFirstStageMax",
            value = 30
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function CapButtonSecondStageMax()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
        action = "addCapSecondStageMax",
        value = 90
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
  end

function CapFirstStageFirstPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setCapFirstStageFirstPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function CapFirstStageSecondPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setCapFirstStageSecondPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function CapSecondStageFirstPerk()
  local protocolGame = g_game.getProtocolGame()
  if protocolGame then
      local data = {
        action = "setCapSecondStageFirstPerk",
        value = 1
      }
      protocolGame:sendExtendedOpcode(14, json.encode(data))
  end
end

function CapSecondStageSecondPerk()
    local protocolGame = g_game.getProtocolGame()
    if protocolGame then
        local data = {
            action = "setCapSecondStageSecondPerk",
            value = 1
        }
        protocolGame:sendExtendedOpcode(14, json.encode(data))
    end
end

function onMiniWindowClose()
  gamePerksMainButton:setOn(false)

end



function print_r ( t ) 
  local print_r_cache={}
  local function sub_print_r(t,indent)
      if (print_r_cache[tostring(t)]) then
          print(indent.."*"..tostring(t))
      else
          print_r_cache[tostring(t)]=true
          if (type(t)=="table") then
              for pos,val in pairs(t) do
                  if (type(val)=="table") then
                      print(indent.."["..pos.."] => "..tostring(t).." {")
                      sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                      print(indent..string.rep(" ",string.len(pos)+6).."}")
                  else
                      print(indent.."["..pos.."] => "..tostring(val))
                  end
              end
          else
              print(indent..tostring(t))
          end
      end
  end
  sub_print_r(t,"  ")
end