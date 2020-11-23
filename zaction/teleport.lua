-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- settings 内的元素结构
-- {
--   speed = 0 ,
--   items = { { name , count } }
-- }
SIEXHSTeleport =
{
	speedItemName = "siexhs-item-teleport-speed" ,
	limitUpItemName = "siexhs-item-teleport-limit-up" ,
	limitDownItemName = "siexhs-item-teleport-limit-down" ,
	
	delay = 120 ,
	
	settingsDefault =
	{
		speed = 0 ,
		items = {}
	}
}
SIEXHSTeleport.limitUpItemNameLength = #SIEXHSTeleport.limitUpItemName
SIEXHSTeleport.limitDownItemNameLength = #SIEXHSTeleport.limitDownItemName

-- ------------------------------------------------------------------------------------------------
-- ---------- 功能方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSTeleport.GetEntity( data )
	return game.get_surface( data[2] ).find_entity( data[1] , data[3] )
end

function SIEXHSTeleport.GetSettings( entity )
	local logistic = entity.get_logistic_point( defines.logistic_member_index.logistic_container )
	local settings = table.deepcopy( SIEXHSTeleport.settingsDefault )
	if logistic.filters then
		local limitUp = nil
		local limitDown = nil
		for i , filter in pairs( logistic.filters ) do
			if filter.name == SIEXHSTeleport.speedItemName then settings.speed = filter.count
			elseif #filter.name >= SIEXHSTeleport.limitUpItemNameLength and filter.name:sub( 1 , SIEXHSTeleport.limitUpItemNameLength ) == SIEXHSTeleport.limitUpItemName then limitUp = filter.count
			elseif #filter.name >= SIEXHSTeleport.limitDownItemNameLength and filter.name:sub( 1 , SIEXHSTeleport.limitDownItemNameLength ) == SIEXHSTeleport.limitDownItemName then limitDown = filter.count
			else
				local item = { filter.name , filter.count , 0 , 0 }
				if limitUp then
					item[3] = limitUp
					limitUp = nil
				end
				if limitDown then
					item[4] = limitDown
					limitDown = nil
				end
				table.insert( settings.items , item )
			end
		end
	end
	return settings
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 公用方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSTeleport.Teleport( event )
	local currentTick = math.fmod( event.tick , SIEXHSTeleport.delay ) + 1
	for forceIndex , forceData in pairs( containerData ) do
		local storage = forceData.s
		local list = forceData.i
		if list then
			local maxSize = #list
			for index = currentTick , maxSize , SIEXHSTeleport.delay do
				if index > maxSize then break end
				local entity = SIEXHSTeleport.GetEntity( list[index] )
				if not entity.to_be_deconstructed( forceIndex ) then
					local inventory = entity.get_inventory( defines.inventory.chest )
					if not inventory.is_empty() then
						local settings = SIEXHSTeleport.GetSettings( entity )
						if settings.speed > 0 then
							for i , itemData in pairs( settings.items ) do
								local name = itemData[1]
								local count = inventory.get_item_count( name )
								if count > itemData[2] then
									local b = true
									for n , storageItemData in pairs( storage ) do
										if storageItemData[1] == name then
											if itemData[3] > 0 and itemData[3] < storageItemData[2] then
												b = false
												break
											end
											if itemData[4] > 0 and itemData[4] > storageItemData[2] then
												b = false
												break
											end
											storageItemData[2] = storageItemData[2] + inventory.remove{ name = name , count = math.min( count-itemData[2] , settings.speed ) }
											b = false
											break
										end
									end
									if b then table.insert( storage , { name , inventory.remove{ name = name , count = math.min( count-itemData[2] , settings.speed ) } } ) end
								end
							end
						end
					end
				end
			end
		end
		list = forceData.o
		if list then
			local maxSize = #list
			for index = currentTick , maxSize , SIEXHSTeleport.delay do
				if index > maxSize then break end
				local entity = SIEXHSTeleport.GetEntity( list[index] )
				if not entity.to_be_deconstructed( forceIndex ) then
					local settings = SIEXHSTeleport.GetSettings( entity )
					if settings.speed > 0 then
						local inventory = entity.get_inventory( defines.inventory.chest )
						for i , itemData in pairs( settings.items ) do
							local name = itemData[1]
							local count = inventory.get_item_count( name )
							if count < itemData[2] then
								local storageItemIndex = 0
								local storageItemCount = 0
								for n , storageItemData in pairs( storage ) do
									if storageItemData[1] == name then
										if itemData[3] > 0 and itemData[3] < storageItemData[2] then
											storageItemCount = 0
											break
										end
										if itemData[4] > 0 and itemData[4] > storageItemData[2] then
											storageItemCount = 0
											break
										end
										storageItemIndex = n
										storageItemCount = storageItemData[2]
										break
									end
								end
								if storageItemCount > 0 then
									local insertCount = inventory.insert{ name = name , count = math.min( math.min( itemData[2]-count , storageItemCount ) , settings.speed ) }
									storageItemCount = storageItemCount - insertCount
									storage[storageItemIndex][2] = storageItemCount
								end
							end
						end
					end
				end
			end
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 事件注册 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEventBus.Add( SIEvents.on_tick , SIEXHSTeleport.Teleport )