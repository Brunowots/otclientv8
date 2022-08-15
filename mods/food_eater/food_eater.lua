
foodeaterButton = nil
foodeaterWindow = nil
itemWidget = nil

function init()
  ProtocolGame.registerExtendedOpcode(14, onExtendedOpcode)
  foodeaterButton = modules.client_topmenu.addRightToggleButton('foodeaterButton', tr('Food Eater'), '/food_eater/food_eater/food_eater', closing)
  foodeaterButton:setOn(false)

  foodeaterWindow = g_ui.displayUI('food_eater')
  foodeaterWindow:setVisible(false)

  --get help values
  allTabs = foodeaterWindow:recursiveGetChildById('allTabs')
  allTabs:setContentWidget(foodeaterWindow:getChildById('optionsTabContent'))
end

function terminate()
  ProtocolGame.unregisterExtendedOpcode(14, onExtendedOpcode)
  foodeaterButton:destroy()
  foodeaterWindow:destroy()
end

function closing()
  if foodeaterButton:isOn() then
    foodeaterWindow:setVisible(false)
    foodeaterButton:setOn(false)
  else
    foodeaterWindow:setVisible(true)
    foodeaterButton:setOn(true)
  end
end

function banana()
    local protocolGame = g_game.getProtocolGame()
    local myData = {
        a = "string",
        b = 123,
        c = {
            x = "string in table",
            y = 456
        }
    }
    if foodeaterButton:isOn() then
    if protocolGame then
        protocolGame:sendExtendedOpcode(14, json.encode(myData))
    end
    else
    foodeaterWindow:setVisible(true)
    foodeaterButton:setOn(true)
    end
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

    print(json_data.foo)
    print(json_data.bar)
    print("TEST1");
    itemWidget = foodeaterWindow:getChildById('itemWidget')
    print(itemWidget)
    itemWidget:setItemId(3587)
end

function melon()
local protocolGame = g_game.getProtocolGame()
  if foodeaterButton:isOn() then
  if protocolGame then
      protocolGame:sendExtendedOpcode(14, 2)
    end
  else
    foodeaterWindow:setVisible(true)
    foodeaterButton:setOn(true)
  end
end
function cake()
local protocolGame = g_game.getProtocolGame()
  if foodeaterButton:isOn() then
  if protocolGame then
      protocolGame:sendExtendedOpcode(14, 3)
    end
  else
    foodeaterWindow:setVisible(true)
    foodeaterButton:setOn(true)
  end
end
function onMiniWindowClose()
  foodeaterButton:setOn(false)

end