-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEXHSTeleporter =
{
	regex = "siexhs%-container%-teleporter" ,
	position = #"siexhs-container-teleporter-" + 1 ,
	
	speedItemName = "siexhs-item-teleport-speed" ,
	selectItemName = "siexhs-item-teleport-item" ,
	
	forceDataDefault =
	{
		i = {} ,
		o = {} ,
		s = {}
	}
}

-- ------------------------------------------------------------------------------------------------
-- ---------- 公用方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function SIEXHSTeleporter.Build( event )
	local entity = event.created_entity or event.entity
	local name = entity.name
	if name:find( SIEXHSTeleporter.regex ) then
		local typeCode = name:sub( SIEXHSTeleporter.position , SIEXHSTeleporter.position )
		local forceIndex = entity.force.index
		local forceData = containerData[forceIndex]
		if not forceData then
			forceData = table.deepcopy( SIEXHSTeleporter.forceDataDefault )
			containerData[forceIndex] = forceData
		end
		table.insert( forceData[typeCode] , { name , entity.surface.index , { entity.position.x , entity.position.y } , NewEntityIndex() , nil } )
		-- 添加请求
		entity.set_request_slot( SIEXHSTeleporter.speedItemName , 1 )
		entity.set_request_slot( { name = SIEXHSTeleporter.selectItemName , count = 0 } , 2 )
	end
end

function SIEXHSTeleporter.Destroy( event )
	local entity = event.entity
	local name = entity.name
	if name:find( SIEXHSTeleporter.regex ) then
		local forceData = containerData[entity.force.index] or {}
		local position = entity.position
		local surfaceIndex = entity.surface.index
		local list = forceData[name:sub( SIEXHSTeleporter.position , SIEXHSTeleporter.position )] or {}
		for i , v in pairs( list ) do
			if v[1] == name and v[2] == surfaceIndex and v[3][1] == position.x and v[3][2] == position.y then
				table.remove( list , i )
				break
			end
		end
	end
end

-- ------------------------------------------------------------------------------------------------
-- ---------- 事件注册 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIEventBus
.Add( SIEvents.on_built_entity , SIEXHSTeleporter.Build )
.Add( SIEvents.on_robot_built_entity , SIEXHSTeleporter.Build )
.Add( SIEvents.script_raised_built , SIEXHSTeleporter.Build )

.Add( SIEvents.on_player_mined_entity , SIEXHSTeleporter.Destroy )
.Add( SIEvents.on_robot_mined_entity , SIEXHSTeleporter.Destroy )
.Add( SIEvents.on_entity_died , SIEXHSTeleporter.Destroy )
.Add( SIEvents.script_raised_destroy , SIEXHSTeleporter.Destroy )