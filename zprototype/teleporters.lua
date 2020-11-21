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
		structure = { { "splitter" , 8 } , { "fast-inserter" , 5 } , { "electric-mining-drill" , 3 } }
	} ,
	{
		small = { 1 , 29 , 3 , 120 } ,
		normal = { 3 , 89 , 3 , 240 , { { "logistic-science-pack" , 250 } } } ,
		structure = { { "laser-turret" , 7 } , { "assembling-machine-2" , 3 } , { "locomotive" , 3 } }
	} ,
	{
		small = { 1 , 59 , 4 , 240 } ,
		normal = { 3 , 179 , 5 , 480 , { { "iron-chest" , 350 } } } ,
		structure = { { "production-science-pack" , 5 } , { "power-switch" , 3 } , { "low-density-structure" , 3 } , { "substation" , 2 } }
	} ,
	{
		small = { 1 , 119 , 6 , 480 } ,
		normal = { 3 , 359 , 9 , 960 , { { "steel-chest" , 350 } } } ,
		structure = { { "express-underground-belt" , 5 } , { "fusion-reactor-equipment" , 3 } , { "effectivity-module-3" , 3 } , { "uranium-fuel-cell" , 5 } }
	} ,
	{
		small = { 1 , 239 , 8 , 960 } ,
		normal = { 3 , 719 , 13 , 1920 , { { "logistic-chest-buffer" , 350 } } } ,
		structure = { { "utility-science-pack" , 5 } , { "rocket-control-unit" , 10 } , { "satellite" , 1 } , { "rocket-silo" , 1 } }
	}
}

-- ------------------------------------------------------------------------------------------------
-- -------- 创建辅助物品 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-teleporter" ).NewItem( "teleport-speed" , 1000 )

-- ------------------------------------------------------------------------------------------------
-- ---- 创建物品实体配方科技 ----------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local lastItemName = {}
for level = 1 , SIEXHS.maxLevel , 1 do
	local teleporterData = list[level]
	
	local structureItem = SIGen.NewSubGroup( "hyperspace-teleporter-base" )
	.NewItem( "hyperspace-structure-mk"..level , 5 )
	.SetLocalisedNames{ "SIEXHS.name-structure" , level }
	.SetLocalisedDescriptions{ "SIEXHS.desc-structure" }
	.GetCurrentEntityName()
	
	SIGen.NewRecipe( structureItem )
	.SetLocalisedNames{ "SIEXHS.name-structure" , level }
	.SetLocalisedDescriptions{ "SIEXHS.desc-structure" }
	.SetEnergy( #teleporterData.structure*level*3 )
	.SetEnabled( true )
	.AddCosts( SIPackers.IngredientsWithList( teleporterData.structure ) )
	.AddCosts( SIEXHS.coreItem , level )
	.AddResults( structureItem )
	.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , level , nil , nil , level ) )
	.SetSelfIcon( "hyperspace-structure-mk"..level )
	
	for typeCode , typeCodeString in pairs( typeCodes ) do
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
			.AddCosts( SIPackers.IngredientsWithList( entityData[5] ) )
			.AddCosts( structureItem , 40 )
			.AddCosts( SIEXHS.powerItems[level] , level*200 )
			.AddCosts( SIEXHS.coreItem , level )
			.AddCosts( SIEXHS.gelItem , level*150 )
			.AddCosts( lastItemName[typeCode] )
			.AddResults( itemName )
			.AddLastLevel( 2 )
			
			lastItemName[typeCode] = itemName
		end
	end
end