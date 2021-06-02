-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEXHSTeleporterView =
{
	interfaceId = "siexhs-teleporter" ,
	toolbarButtonId = "SIEXHSTeleporterToolbarButton" ,
	toolbarButtonName = "siexhs-teleporter-toolbar-button" ,
	toolbarItemName = "siexhs-item-teleporter" ,
	
	iconRegex = "siexhs%-teleporter%-button" ,
	iconPosition = #"siexhs-teleporter-button-" + 1 ,
	
	editRegex = "siexhs%-teleporter%-edit" ,
	editPosition = #"siexhs-teleporter-edit-" + 1 ,
	
	settingsDefaultData =
	{
		view = nil ,
		list = nil ,
		selectType = nil ,
		selectIndex = nil ,
		textField = nil
	}
}

-- ------------------------------------------------------------------------------------------------
-- ---------- 窗口方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSTeleporterView.OpenView( playerIndex )
	local player = game.players[playerIndex]
	local settings = SIEXHSTeleporterView.GetSettings( playerIndex )
	if settings.view then SIEXHSTeleporterView.CloseView( playerIndex )
	else
		local view = player.gui.left.add{ type = "frame" , name = "siexhs-teleporter-view" , caption = { "SIEXHS.teleporter-view-title" } , direction = "vertical" , style = "siexhs-teleporter-view" }
		
		local flow = view.add{ type = "flow" , direction = "horizontal" }
		flow.add{ type = "label" , caption = { "SIEXHS.teleporter-view-description" } , style = "siexhs-label-text" }
		
		view.add{ type = "line" , direction = "horizontal" }
		
		flow = view.add{ type = "flow" , direction = "horizontal" }
		flow.add{ type = "button" , name = "siexhs-teleporter-fresh" , caption = { "SIEXHS.teleporter-view-fresh" } , style = "siexhs-button-gray" }
		settings.list = view.add{ type = "scroll-pane" , horizontal_scroll_policy = "never" , vertical_scroll_policy = "auto-and-reserve-space" }.add{ type = "table" , column_count = 4 , style = "siexhs-list" }
		SIEXHSTeleporterView.FreshList( playerIndex , settings )
		
		view.add{ type = "line" , direction = "horizontal" }
		
		flow = view.add{ type = "flow" , direction = "horizontal" }
		flow.add{ type = "button" , name = "siexhs-teleporter-close" , caption={ "SIEXHS.teleporter-view-close" } , style = "siexhs-button-red" }
		
		settings.view = view
	end
end

function SIEXHSTeleporterView.CloseView( playerIndex )
	local settings = SIEXHSTeleporterView.GetSettings( playerIndex )
	if settings then
		if settings.view then
			settings.view.destroy()
			settings.view = nil
			settings.list = nil
			settings.selectType = nil
			settings.selectIndex = nil
			settings.textField = nil
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 功能方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSTeleporterView.ShowViewByPlayerIndex( playerIndex )
	SIEXHSTeleporterView.OpenView( playerIndex )
end

function SIEXHSTeleporterView.HideViewByPlayerIndex( playerIndex )
	SIEXHSTeleporterView.CloseView( playerIndex )
end

function SIEXHSTeleporterView.ShowViews()
	for playerIndex , settings in pairs( teleporterView ) do SIEXHSTeleporterView.OpenView( playerIndex ) end
end

function SIEXHSTeleporterView.HideViews()
	for playerIndex , settings in pairs( teleporterView ) do SIEXHSTeleporterView.CloseView( playerIndex ) end
end

function SIEXHSTeleporterView.GetSettings( playerIndex )
	local settings = teleporterView[playerIndex]
	if not settings then
		settings = table.deepcopy( SIEXHSTeleporterView.settingsDefaultData )
		teleporterView[playerIndex] = settings
	end
	return settings
end

function SIEXHSTeleporterView.TeleportPlayer( playerIndex , typeCode , index )
	local player = game.players[playerIndex]
	local forceData = containerData[player.force.index]
	if not forceData then
		player.print( { "SIEXHS.teleporter-unknown-force" } , SIColors.printColor.orange )
		return
	end
	local container = forceData[typeCode][index]
	if not container then
		player.print( { "SIEXHS.teleporter-unknown-container" } , SIColors.printColor.orange )
		return
	end
	local surface = game.get_surface( container[2] )
	local position = container[3]
	local px = position[1]
	local py = position[2]
	local teleported = false
	local character = player.character
	if character then
		for i = 0 , 15 , 1 do
			for x = px-i , px+i , 1 do
				for y = py-i , py+i , 1 do
					local entities = surface.find_entities{ { x-0.3 , y-0.3 } , { x+0.3 , y+0.3 } }
					if #entities < 1 then
						local tile = surface.get_tile( x , y )
						local mask = false
						for layer , value in pairs( character.prototype.collision_mask ) do
							if tile.collides_with( layer ) then
								mask = true
								break
							end
						end
						if not mask then
							px = x
							py = y
							teleported = true
							break
						end
					end
				end
				if teleported then break end
			end
			if teleported then break end
		end
	else teleported = true end
	if teleported then
		player.teleport( { px , py } , surface )
		player.print( { "SIEXHS.teleporter-successful" , surface.name , px , py } , SIColors.printColor.green )
	else player.print( { "SIEXHS.teleporter-unknown-position" } , SIColors.printColor.orange ) end
end

function SIEXHSTeleporterView.FreshList( playerIndex , settings )
	if settings.list then
		local list = settings.list
		list.clear()
		local forceData = containerData[game.players[playerIndex].force.index] or {}
		local containersI = forceData.i or {}
		local containersO = forceData.o or {}
		list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-label-icon" } , style="siexhs-label-icon" }
		list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-label-name" } , style="siexhs-label-long" }
		list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-label-location" } , style="siexhs-label-long" }
		list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-label-options" } , style="siexhs-label-icon" }
		if #containersI+#containersO == 0 then
			list.add{ type = "sprite-button" , sprite = "item/sicfl-item-icon-empty" , style = "siexhs-list-icon" }
			list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-entity-none" } , style="siexhs-label-long" }
			list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-entity-location-unknown" } , style="siexhs-label-long" }
		else
			for i , v in pairs( containersI ) do
				if settings.selectType == "i" and settings.selectIndex == v[4] then
					list.add{ type = "sprite-button" , name = "siexhs-teleporter-button-i"..i , tooltip = { "SIEXHS.teleporter-view-entity-icon" } , sprite = "entity/"..v[1] , style = "siexhs-list-icon" }
					settings.textField = list.add{ type = "textfield" , text = v[5] or "" , tooltip = { "SIEXHS.teleporter-view-entity-name" } , style = "siexhs-textfield-long" }
					list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-entity-location" , game.get_surface( v[2] ).name , v[3][1] , v[3][2] } , style="siexhs-label-long" }
					list.add{ type = "sprite-button" , name = "siexhs-teleporter-save" , tooltip = { "SIEXHS.teleporter-view-entity-save" } , sprite = "item/sicfl-item-icon-save" , style = "siexhs-list-icon" }
				else
					list.add{ type = "sprite-button" , name = "siexhs-teleporter-button-i"..i , tooltip = { "SIEXHS.teleporter-view-entity-icon" } , sprite = "entity/"..v[1] , style = "siexhs-list-icon" }
					list.add{ type = "label" , caption = v[5] or game.entity_prototypes[v[1]].localised_name , style="siexhs-label-long" }
					list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-entity-location" , game.get_surface( v[2] ).name , v[3][1] , v[3][2] } , style="siexhs-label-long" }
					list.add{ type = "sprite-button" , name = "siexhs-teleporter-edit-i"..v[4] , tooltip = { "SIEXHS.teleporter-view-entity-edit" } , sprite = "item/sicfl-item-icon-edit" , style = "siexhs-list-icon" }
				end
			end
			for i , v in pairs( containersO ) do
				if settings.selectType == "o" and settings.selectIndex == v[4] then
					list.add{ type = "sprite-button" , name = "siexhs-teleporter-button-o"..i , tooltip = { "SIEXHS.teleporter-view-entity-icon" } , sprite = "entity/"..v[1] , style = "siexhs-list-icon" }
					settings.textField = list.add{ type = "textfield" , text = v[5] or "" , tooltip = { "SIEXHS.teleporter-view-entity-name" } , style = "siexhs-textfield-long" }
					list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-entity-location" , game.get_surface( v[2] ).name , v[3][1] , v[3][2] } , style="siexhs-label-long" }
					list.add{ type = "sprite-button" , name = "siexhs-teleporter-save" , tooltip = { "SIEXHS.teleporter-view-entity-save" } , sprite = "item/sicfl-item-icon-save" , style = "siexhs-list-icon" }
				else
					list.add{ type = "sprite-button" , name = "siexhs-teleporter-button-o"..i , tooltip = { "SIEXHS.teleporter-view-entity-icon" } , sprite = "entity/"..v[1] , style = "siexhs-list-icon" }
					list.add{ type = "label" , caption = v[5] or game.entity_prototypes[v[1]].localised_name , style="siexhs-label-long" }
					list.add{ type = "label" , caption = { "SIEXHS.teleporter-view-entity-location" , game.get_surface( v[2] ).name , v[3][1] , v[3][2] } , style="siexhs-label-long" }
					list.add{ type = "sprite-button" , name = "siexhs-teleporter-edit-o"..v[4] , tooltip = { "SIEXHS.teleporter-view-entity-edit" } , sprite = "item/sicfl-item-icon-edit" , style = "siexhs-list-icon" }
				end
			end
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 公用方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSTeleporterView.OnInit( event )
	SIToolbar.AddTool( SIEXHSTeleporterView.toolbarButtonId , SIEXHSTeleporterView.toolbarButtonName , SIEXHSTeleporterView.toolbarItemName , "SIEXHS.teleporter-toolbar-button" , "SIEXHS.teleporter-toolbar-tooltip" , SIEXHSTeleporterView.interfaceId , "ShowViewByPlayerIndex" )
end

function SIEXHSTeleporterView.OnOpenView( event )
	SIEXHSTeleporterView.OpenView( event.player_index )
end

function SIEXHSTeleporterView.OnClickView( event )
	local element = event.element
	if element.valid then
		local name = element.name
		if name == "siexhs-teleporter-fresh" then
			local playerIndex = event.player_index
			SIEXHSTeleporterView.FreshList( playerIndex , SIEXHSTeleporterView.GetSettings( playerIndex ) )
		elseif name == "siexhs-teleporter-close" then SIEXHSTeleporterView.CloseView( event.player_index )
		elseif name == "siexhs-teleporter-save" then
			local playerIndex = event.player_index
			local player = game.players[playerIndex]
			local settings = SIEXHSTeleporterView.GetSettings( playerIndex )
			local list = {}
			local forceData = containerData[player.force.index] or {}
			if settings.selectType == "i" then list = forceData.i or {}
			elseif settings.selectType == "o" then list = forceData.o or {} end
			local b = false
			for i , v in pairs( list ) do
				if settings.selectIndex == v[4] then
					if settings.textField.text == "" then v[5] = nil
					else v[5] = settings.textField.text end
					b = true
				end
			end
			if b then
				if settings.textField.text == "" then player.print( { "SIEXHS.teleporter-view-entity-name-save-clear" } , SIColors.printColor.green )
				else player.print( { "SIEXHS.teleporter-view-entity-name-save" , settings.textField.text } , SIColors.printColor.green ) end
				settings.selectType = nil
				settings.selectIndex = nil
				settings.textField = nil
				SIEXHSTeleporterView.FreshList( playerIndex , settings )
			else player.print( { "SIEXHS.teleporter-view-entity-name-save-not" } , SIColors.printColor.orange ) end
		elseif name:find( SIEXHSTeleporterView.iconRegex ) then
			local data = name:sub( SIEXHSTeleporterView.iconPosition )
			local playerIndex = event.player_index
			SIEXHSTeleporterView.TeleportPlayer( playerIndex , data:sub( 1 , 1 ) , tonumber( data:sub( 2 ) ) )
			SIEXHSTeleporterView.FreshList( playerIndex , SIEXHSTeleporterView.GetSettings( playerIndex ) )
		elseif name:find( SIEXHSTeleporterView.editRegex ) then
			local data = name:sub( SIEXHSTeleporterView.editPosition )
			local playerIndex = event.player_index
			local settings = SIEXHSTeleporterView.GetSettings( playerIndex )
			settings.selectType = data:sub( 1 , 1 )
			settings.selectIndex = tonumber( data:sub( 2 ) )
			SIEXHSTeleporterView.FreshList( playerIndex , settings )
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 事件注册 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEventBus
.Init( SIEXHSTeleporterView.OnInit )
.Add( "siexhs-teleporter" , SIEXHSTeleporterView.OnOpenView )
.Add( SIEvents.on_gui_click , SIEXHSTeleporterView.OnClickView )

remote.add_interface( SIEXHSTeleporterView.interfaceId ,
{
	ShowViewByPlayerIndex = SIEXHSTeleporterView.ShowViewByPlayerIndex ,
	HideViewByPlayerIndex = SIEXHSTeleporterView.HideViewByPlayerIndex ,
	ShowViews = SIEXHSTeleporterView.ShowViews ,
	HideViews = SIEXHSTeleporterView.HideViews
} )