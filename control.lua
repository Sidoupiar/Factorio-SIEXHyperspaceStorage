require( "__SICoreFunctionLibrary__/util" )

needlist( "__SICoreFunctionLibrary__" , "define/load" , "function/load" )
needlist( "__SICoreFunctionLibrary__/runtime/structure" , "sievent_bus" , "siglobal" , "interface_sitoolbar" )

load()

-- ------------------------------------------------------------------------------------------------
-- ---------- 装载数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- containerView / teleporterView 内的元素结构
-- playerIndex =
-- {
--   view = viewElement ,
--   list = listElement
-- }
--
-- containerData 内的元素结构
-- forceIndex =
-- {
--   i = { { name , surfaceIndex , { x , y } } } ,
--   o = { { name , surfaceIndex , { x , y } } } ,
--   s = { { name , count } }
-- }
SIGlobal.Create( "commonData" )
SIGlobal.Create( "containerView" )
SIGlobal.Create( "teleporterView" )
SIGlobal.Create( "containerData" )
needlist( "zaction" , "view_container" , "view_teleporter" , "event_build" , "teleport" , "hand" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 公共方法 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function NewEntityIndex()
	if not commonData.entityIndex then commonData.entityIndex = 1 end
	local index = commonData.entityIndex
	commonData.entityIndex = commonData.entityIndex + 1
	return index
end