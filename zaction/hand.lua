-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEXHSHand =
{
	onDeathItem = "siexhs-item-hand-on-death"
}

-- ------------------------------------------------------------------------------------------------
-- ---------- 功能方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
-- ---------- 公用方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSHand.OnDeath( event )
	local playerIndex = event.player_index
	local player = game.players[playerIndex]
	local mainInventory = player.get_main_inventory()
	if mainInventory and mainInventory.get_item_count( SIEXHSHand.onDeathItem ) > 0 then
		local removeCount = mainInventory.remove{ name = SIEXHSHand.onDeathItem , count = 1 }
		if removeCount > 0 then
			local forceData = containerData[player.force.index]
			local storage = forceData.s
			for id , key in pairs( defines.inventory ) do
				local inventory = player.get_inventory( key )
				if inventory then
					for name , count in pairs( inventory.get_contents() or {} ) do
						local totalCount = inventory.remove{ name = name , count = count }
						local b = true
						for n , storageItemData in pairs( storage ) do
							if storageItemData[1] == name then
								storageItemData[2] = storageItemData[2] + totalCount
								b = false
								break
							end
						end
						if b then table.insert( storage , { name , totalCount } ) end
					end
				end
			end
			player.print( { "SIEXHS.hand-on-death-use-item-success" } , SIColors.printColor.green )
		else player.print( { "SIEXHS.hand-on-death-use-item-failed" } , SIColors.printColor.orange ) end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 事件注册 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEventBus.Add( SIEvents.on_pre_player_died , SIEXHSHand.OnDeath )