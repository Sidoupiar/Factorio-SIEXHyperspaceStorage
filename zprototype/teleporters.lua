-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local typeCodes = { input = "input" , output = "output" }
local sizeCodes = { small = "-small" , normal = "" }
local list =
{
	{
		small = { 1 , 14 , 2 , 60 , { { SIEXHS.wallItem , 200 } } } ,
		normal = { 3 , 44 , 2 , 120 , { { "steel-plate" , 100 } } } ,
		ingredients = { { "splitter" , 300 } , { "filter-inserter" , 200 } , { "electric-mining-drill" , 100 } }
	} ,
	{
		small = { 1 , 29 , 3 , 120 } ,
		normal = { 3 , 89 , 3 , 240 , { { "logistic-science-pack" , 250 } } } ,
		ingredients = { { "laser-turret" , 250 } , { "assembling-machine-2" , 100 } , { "locomotive" , 100 } }
	} ,
	{
		small = { 1 , 59 , 4 , 240 } ,
		normal = { 3 , 179 , 5 , 480 , { { "iron-chest" , 350 } } } ,
		ingredients = { { "production-science-pack" , 200 } , { "power-switch" , 100 } , { "low-density-structure" , 100 } , { "substation" , 60 } }
	} ,
	{
		small = { 1 , 119 , 6 , 480 } ,
		normal = { 3 , 359 , 9 , 960 , { { "steel-chest" , 350 } } } ,
		ingredients = { { "express-underground-belt" , 200 } , { "fusion-reactor-equipment" , 100 } , { "effectivity-module-3" , 100 } , { "uranium-fuel-cell" , 200 } }
	} ,
	{
		small = { 1 , 239 , 8 , 960 } ,
		normal = { 3 , 719 , 13 , 1920 , { { "logistic-chest-buffer" , 350 } } } ,
		ingredients = { { "utility-science-pack" , 200 } , { "rocket-control-unit" , 400 } , { "satellite" , 35 } , { "rocket-silo" , 35 } }
	}
}

-- ------------------------------------------------------------------------------------------------
-- -------- 创建辅助物品 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-teleporter" ).NewItem( "teleport-speed" , 1000 )

-- ------------------------------------------------------------------------------------------------
-- ---- 创建物品实体配方科技 ----------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

for level = 1 , SIEXHS.maxLevel , 1 do
	local teleporterData = list[level]
	for typeCode , typeCodeString in pairs( typeCodes ) do
		local lastItemName = nil
		for sizeCode , sizeCodeString in pairs( sizeCodes ) do
			local entityData = teleporterData[sizeCode]
			local localisedNames = { "SIEXHS.name-"..typeCodeString..sizeCodeString , level }
			local itemName = SIGen.NewSubGroup( "hyperspace-teleporter-"..typeCodeString )
			.NewContainerLogic( "teleporter-"..typeCodeString..sizeCodeString.."-mk"..level , nil , SITypes.logisticMode.buffer )
			.SetLocalisedNames( localisedNames )
			.SetLocalisedDescriptions{ "SIEXHS.desc-teleporter" , { "SIEXHS.desc-"..typeCodeString } , { "SIEXHS.desc"..sizeCodeString } , { "SIEXHS.desc-use" } }
			.SetProperties( entityData[1] , entityData[1] , entityData[1]*100 , 0 , nil , nil , entityData[2] , entityData[3] )
			.SetRender_notInNetworkIcon( false )
			.GetCurrentEntityItemName()
			
			SIGen.NewRecipe( itemName )
			.SetLocalisedNames{ "SICFL.code-name-recipe" , localisedNames }
			.SetLocalisedDescriptions{ "SIEXHS.desc-recipe-teleporter" , localisedNames }
			.SetEnergy( entityData[4] )
			.SetEnabled( true )
			.AddCosts( SIPackers.IngredientsWithList( teleporterData.ingredients ) )
			.AddCosts( SIPackers.IngredientsWithList( entityData[5] ) )
			.AddCosts( SIEXHS.powerItems[level] , level*200 )
			.AddCosts( SIEXHS.coreItem , level )
			.AddCosts( lastItemName )
			.AddResults( itemName )
			.AddLastLevel( 2 )
			
			lastItemName = itemName
		end
	end
end