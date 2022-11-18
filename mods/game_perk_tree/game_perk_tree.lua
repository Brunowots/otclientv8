
gamePerksMainButton = nil
foodeaterWindow = nil

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
  setButtonDescriptions()

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

function setButtonDescriptions()
  healthButton = foodeaterWindow:getChildById('HealthButton')
  healthButton:setTooltip("Add Healith: \n Knight +5 hp \n Paladin +2 hp \n Sorcerer/Driud +1 hp")

  manaButton = foodeaterWindow:getChildById('ManaButton')
  manaButton:setTooltip("Add Mana: \n Knight +1 mp \n Paladin +3 mp \n Sorcerer/Driud +6 mp")

  capButton = foodeaterWindow:getChildById('CapButton')
  capButton:setTooltip("Add Capacity: \n Knight +5 cap \n Paladin +4 cap \n Sorcerer/Driud +2 cap")
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
    print(json_data.points)
    print(json_data.vocation)
    if json_data.action == "getPlayerData" then
      setPoints(json_data.availablePoints, json_data.maxPoints)
      setupSkillTreeOverlayForVocation(json_data.vocation)
    end

end

function setPoints(availablePoints, maxPoints)
  pointsLabel = foodeaterWindow:getChildById('pointsLabel')
  pointsLabel:setText(tr("Points:") .. " " .. availablePoints .. "/" .. maxPoints)

  -- ultimateHealingPic = foodeaterWindow:getChildById('healthColumnFirstStageSecondSorcPerk')
  -- ultimateHealingPic:setEnabled(false)
end

function setupSkillTreeOverlayForVocation(vocId)
  if vocId == 1 then --sorcerer
    healthColumnFirstStageFirstSorcPerk = foodeaterWindow:getChildById('healthColumnFirstStageFirstSorcPerk')
    healthColumnFirstStageFirstSorcPerk:setVisible(true)
    healthColumnFirstStageSecondSorcPerk = foodeaterWindow:getChildById('healthColumnFirstStageSecondSorcPerk')
    healthColumnFirstStageSecondSorcPerk:setVisible(true)
    manaColumnFirstStageFirstSorcPerk = foodeaterWindow:getChildById('manaColumnFirstStageFirstSorcPerk')
    manaColumnFirstStageFirstSorcPerk:setVisible(true)
    manaColumnFirstStageSecondSorcPerk = foodeaterWindow:getChildById('manaColumnFirstStageSecondSorcPerk')
    manaColumnFirstStageSecondSorcPerk:setVisible(true)
    capColumnFirstStageFirstSorcPerk = foodeaterWindow:getChildById('capColumnFirstStageFirstSorcPerk')
    capColumnFirstStageFirstSorcPerk:setVisible(true)
    capColumnFirstStageSecondSorcPerk = foodeaterWindow:getChildById('capColumnFirstStageSecondSorcPerk')
    capColumnFirstStageSecondSorcPerk:setVisible(true)

    healthColumnSecondStageFirstSorcPerk = foodeaterWindow:getChildById('healthColumnSecondStageFirstSorcPerk')
    healthColumnSecondStageFirstSorcPerk:setVisible(true)
    healthColumnSecondStageSecondSorcPerk = foodeaterWindow:getChildById('healthColumnSecondStageSecondSorcPerk')
    healthColumnSecondStageSecondSorcPerk:setVisible(true)
    manaColumnSecondStageFirstSorcPerk = foodeaterWindow:getChildById('manaColumnSecondStageFirstSorcPerk')
    manaColumnSecondStageFirstSorcPerk:setVisible(true)
    manaColumnSecondStageSecondSorcPerk = foodeaterWindow:getChildById('manaColumnSecondStageSecondSorcPerk')
    manaColumnSecondStageSecondSorcPerk:setVisible(true)
    capColumnSecondStageFirstSorcPerk = foodeaterWindow:getChildById('capColumnSecondStageFirstSorcPerk')
    capColumnSecondStageFirstSorcPerk:setVisible(true)
    capColumnSecondStageSecondSorcPerk = foodeaterWindow:getChildById('capColumnSecondStageSecondSorcPerk')
    capColumnSecondStageSecondSorcPerk:setVisible(true)
  elseif vocId == 2 then -- druid
  elseif vocId == 3 then -- paladin
  elseif vocId == 4 then --knight
  end
end

function HealthButton()
local protocolGame = g_game.getProtocolGame()
  if gamePerksMainButton:isOn() then
  if protocolGame then
      protocolGame:sendExtendedOpcode(14, 3)
    end
  else
    foodeaterWindow:setVisible(true)
    gamePerksMainButton:setOn(true)
  end
end

function ManaButton()
  local protocolGame = g_game.getProtocolGame()
    if gamePerksMainButton:isOn() then
    if protocolGame then
        protocolGame:sendExtendedOpcode(14, 2)
      end
    else
      foodeaterWindow:setVisible(true)
      gamePerksMainButton:setOn(true)
    end
end

function CapButton()
  local protocolGame = g_game.getProtocolGame()
  local myData = {
      a = "string",
      b = 123,
      c = {
          x = "string in table",
          y = 456
      }
  }
  if gamePerksMainButton:isOn() then
  if protocolGame then
      protocolGame:sendExtendedOpcode(14, json.encode(myData))
  end
  else
  foodeaterWindow:setVisible(true)
  gamePerksMainButton:setOn(true)
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