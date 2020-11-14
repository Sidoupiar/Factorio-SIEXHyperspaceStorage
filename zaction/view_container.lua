-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEXHSContainerView =
{
	interfaceId = "siexhs-container" ,
	toolbarButtonId = "SIEXHSContainerToolbarButton" ,
	toolbarButtonName = "siexhs-container-toolbar-button" ,
	toolbarItemName = "siexhs-item-container" ,
	
	settingsDefaultData =
	{
		view = nil ,
		list = nil
	}
}

-- ------------------------------------------------------------------------------------------------
-- ---------- 窗口方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSContainerView.OpenView( playerIndex )
	local player = game.players[playerIndex]
	local settings = SIEXHSContainerView.GetSettings( playerIndex )
	if settings.view then SIEXHSContainerView.CloseView( playerIndex )
	else
		local view = player.gui.left.add{ type = "frame" , name = "siexhs-container-view" , caption = { "SIEXHS.container-view-title" } , direction = "vertical" , style = "siexhs-container-view" }
		
		local flow = view.add{ type = "flow" , direction = "horizontal" }
		flow.add{ type = "label" , caption = { "SIEXHS.container-view-description" } , style = "siexhs-label-text" }
		
		view.add{ type = "line" , direction = "horizontal" }
		
		flow = view.add{ type = "flow" , direction = "horizontal" }
		flow.add{ type = "button" , name = "siexhs-container-clean" , caption = { "SIEXHS.container-view-clean" } , style = "siexhs-button-gray" }
		flow.add{ type = "button" , name = "siexhs-container-fresh" , caption = { "SIEXHS.container-view-fresh" } , style = "siexhs-button-gray" }
		flow.add{ type = "button" , name = "siexhs-container-sort-count" , caption = { "SIEXHS.container-view-sort-count" } , style = "siexhs-button-green" }
		flow.add{ type = "button" , name = "siexhs-container-sort-name" , caption = { "SIEXHS.container-view-sort-name" } , style = "siexhs-button-green" }
		settings.list = view.add{ type = "scroll-pane" , horizontal_scroll_policy = "never" , vertical_scroll_policy = "auto-and-reserve-space" }.add{ type = "table" , column_count = 3 , style = "siexhs-list" }
		SIEXHSContainerView.FreshList( playerIndex , settings )
		
		view.add{ type = "line" , direction = "horizontal" }
		
		flow = view.add{ type = "flow" , direction = "horizontal" }
		flow.add{ type = "button" , name = "siexhs-container-close" , caption={ "SIEXHS.container-view-close" } , style = "siexhs-button-red" }
		
		settings.view = view
	end
end

function SIEXHSContainerView.CloseView( playerIndex )
	local settings = SIEXHSContainerView.GetSettings( playerIndex )
	if settings then
		if settings.view then
			settings.view.destroy()
			settings.view = nil
			settings.list = nil
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 功能方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSContainerView.ShowViewByPlayerIndex( playerIndex )
	SIEXHSContainerView.OpenView( playerIndex )
end

function SIEXHSContainerView.HideViewByPlayerIndex( playerIndex )
	SIEXHSContainerView.CloseView( playerIndex )
end

function SIEXHSContainerView.ShowViews()
	for playerIndex , settings in pairs( containerView ) do SIEXHSContainerView.OpenView( playerIndex ) end
end

function SIEXHSContainerView.HideViews()
	for playerIndex , settings in pairs( containerView ) do SIEXHSContainerView.CloseView( playerIndex ) end
end

function SIEXHSContainerView.GetSettings( playerIndex )
	local settings = containerView[playerIndex]
	if not settings then
		settings = table.deepcopy( SIEXHSContainerView.settingsDefaultData )
		containerView[playerIndex] = settings
	end
	return settings
end

function SIEXHSContainerView.SortData( playerIndex , index )
	local settings = SIEXHSContainerView.GetSettings( playerIndex )
	if settings then
		local forceData = containerData[game.players[playerIndex].force.index]
		if forceData then if forceData.s then table.sort( forceData.s , function( a , b ) return a[index] > b[index] end ) end end
		SIEXHSContainerView.FreshList( playerIndex , settings )
	end
end

function SIEXHSContainerView.CleanData( playerIndex )
	local settings = SIEXHSContainerView.GetSettings( playerIndex )
	if settings then
		local forceData = containerData[game.players[playerIndex].force.index]
		if forceData and forceData.s then
			local s = table.deepcopy( forceData.s )
			for i = #s , 1 , -1 do if s[i][2] == 0 then table.remove( s , i ) end end
			forceData.s = s
		end
		SIEXHSContainerView.FreshList( playerIndex , settings )
	end
end

function SIEXHSContainerView.FreshList( playerIndex , settings )
	if settings.list then
		local list = settings.list
		list.clear()
		local forceData = containerData[game.players[playerIndex].force.index] or {}
		local storage = forceData.s or {}
		list.add{ type = "label" , caption = { "SIEXHS.container-view-label-icon" } , style="siexhs-label-icon" }
		list.add{ type = "label" , caption = { "SIEXHS.container-view-label-name" } , style="siexhs-label-long" }
		list.add{ type = "label" , caption = { "SIEXHS.container-view-label-count" } , style="siexhs-label-long" }
		if #storage == 0 then
			list.add{ type = "sprite-button" , sprite = "item/sicfl-item-empty" , style = "siexhs-list-icon" }
			list.add{ type = "label" , caption = { "SIEXHS.container-view-item-none" } , style="siexhs-label-long" }
			list.add{ type = "label" , caption = { "SIEXHS.container-view-item-count-infinity" } , style="siexhs-label-long" }
		else
			for i , v in pairs( storage ) do
				list.add{ type = "sprite-button" , sprite = "item/"..v[1] , style = "siexhs-list-icon" }
				list.add{ type = "label" , caption = game.item_prototypes[v[1]].localised_name , style="siexhs-label-long" }
				list.add{ type = "label" , caption = { "SIEXHS.container-view-item-count" , v[2] } , style="siexhs-label-long" }
			end
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 公用方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSContainerView.OnInit( event )
	remote.call( "sicfl-toolbar" , "AddTool" , SIEXHSContainerView.toolbarButtonId , SIEXHSContainerView.toolbarButtonName , SIEXHSContainerView.toolbarItemName , "SIEXHS.container-toolbar-button" , "SIEXHS.container-toolbar-tooltip" , SIEXHSContainerView.interfaceId , "ShowViewByPlayerIndex" )
end

function SIEXHSContainerView.OnOpenView( event )
	SIEXHSContainerView.OpenView( event.player_index )
end

function SIEXHSContainerView.OnClickView( event )
	local element = event.element
	if element.valid then
		local name = element.name
		if name == "siexhs-container-sort-name" then SIEXHSContainerView.SortData( event.player_index , 1 )
		elseif name == "siexhs-container-sort-count" then SIEXHSContainerView.SortData( event.player_index , 2 )
		elseif name == "siexhs-container-fresh" then
			local playerIndex = event.player_index
			SIEXHSContainerView.FreshList( playerIndex , SIEXHSContainerView.GetSettings( playerIndex ) )
		elseif name == "siexhs-container-clean" then SIEXHSContainerView.CleanData( event.player_index )
		elseif name == "siexhs-container-close" then SIEXHSContainerView.CloseView( event.player_index ) end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 事件注册 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEventBus
.Init( SIEXHSContainerView.OnInit )
.Add( "siexhs-container" , SIEXHSContainerView.OnOpenView )
.Add( SIEvents.on_gui_click , SIEXHSContainerView.OnClickView )

remote.add_interface( SIEXHSContainerView.interfaceId ,
{
	ShowViewByPlayerIndex = SIEXHSContainerView.ShowViewByPlayerIndex ,
	HideViewByPlayerIndex = SIEXHSContainerView.HideViewByPlayerIndex ,
	ShowViews = SIEXHSContainerView.ShowViews ,
	HideViews = SIEXHSContainerView.HideViews
} )