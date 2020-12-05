-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local typeCodes = { input = "input" , output = "output" }
local sizeCodes = { small = "-small" , normal = "" }
local list =
{
	{
		small = { 1 , 19 , 2 , 150 , { { SIEXHS.wallItem , 200 } } } ,
		normal = { 3 , 59 , 3 , 300 , { { "steel-plate" , 100 } } } ,
		structure = { { "splitter" , 8 } , { "fast-inserter" , 5 } , { "electric-mining-drill" , 3 } }
	} ,
	{
		small = { 1 , 39 , 3 , 300 , { { SIEXHS.wallItem , 300 } } } ,
		normal = { 3 , 119 , 6 , 600 , { { "logistic-science-pack" , 250 } } } ,
		structure = { { "laser-turret" , 7 } , { "assembling-machine-2" , 3 } , { "locomotive" , 3 } }
	} ,
	{
		small = { 1 , 79 , 4 , 600 , { { SIEXHS.wallItem , 500 } } } ,
		normal = { 3 , 239 , 10 , 1200 , { { "iron-chest" , 350 } } } ,
		structure = { { "production-science-pack" , 5 } , { "power-switch" , 3 } , { "low-density-structure" , 3 } , { "substation" , 2 } }
	} ,
	{
		small = { 1 , 159 , 6 , 1200 , { { SIEXHS.wallItem , 800 } } } ,
		normal = { 3 , 479 , 14 , 2400 , { { "steel-chest" , 350 } } } ,
		structure = { { "express-underground-belt" , 5 } , { "fusion-reactor-equipment" , 3 } , { "effectivity-module-3" , 3 } , { "uranium-fuel-cell" , 5 } }
	} ,
	{
		small = { 1 , 319 , 8 , 2400 , { { SIEXHS.wallItem , 1200 } } } ,
		normal = { 3 , 959 , 20 , 4800 , { { "logistic-chest-buffer" , 350 } } } ,
		structure = { { "utility-science-pack" , 5 } , { "rocket-control-unit" , 10 } , { "satellite" , 1 } , { "rocket-silo" , 1 } }
	}
}

-- ------------------------------------------------------------------------------------------------
-- -------- 创建辅助物品 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local speedItem = SIGen.NewSubGroup( "hyperspace-flags" ).NewItem( "teleport-item" , 1000 ).NewItem( "teleport-speed" , 1000 ).GetCurrentEntityName()
for i = 1 , 4 , 1 do SIGen.NewItem( "teleport-limit-up-"..i , 10000 ).NewItem( "teleport-limit-down-"..i , 1000 ) end

table.insert( list[1].structure , { speedItem , 5000 } )
SIGen.NewSubGroup( "hyperspace-base" )
.NewRecipe( speedItem )
.SetEnabled( true )
.SetRecipeTypes( SIEXHS.recipeType )
.AddCosts( "transport-belt" , 4 )
.AddCosts( "copper-plate" , 2 )
.AddCosts( SIEXHS.coreItem )
.AddResults( speedItem , 1000 )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 1 , nil , nil , 1 ) )
.SetSelfIcon( "teleport-speed" )

-- ------------------------------------------------------------------------------------------------
-- ---- 创建物品实体配方科技 ----------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local lastItemName = {}
for level = 1 , SIEXHS.maxLevel , 1 do
	local teleporterData = list[level]
	
	local structureItem = SIGen.NewSubGroup( "hyperspace-structure" )
	.NewItem( "hyperspace-structure-mk"..level , 5 )
	.SetLocalisedNames{ "SIEXHS.name-structure" , level }
	.SetLocalisedDescriptions{ "SIEXHS.desc-structure" }
	.GetCurrentEntityName()
	
	SIGen.NewRecipe( structureItem )
	.SetLocalisedNames{ "SIEXHS.name-structure" , level }
	.SetLocalisedDescriptions{ "SIEXHS.desc-structure" }
	.SetEnergy( #teleporterData.structure*math.pow( level , 2 )*5 )
	.SetEnabled( true )
	.SetRecipeTypes( SIEXHS.recipeType )
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
			.SetLocalisedDescriptions{ "SIEXHS.desc-teleporter" , { "SIEXHS.desc-"..typeCodeString } , entityData[3] , { "SIEXHS.desc"..sizeCodeString } , { "SIEXHS.desc-use" } }
			.SetProperties( entityData[1] , entityData[1] , entityData[1]*300 , 0 , nil , nil , entityData[2] , entityData[3] )
			.SetCorpse( nil , "nuke-explosion" )
			.SetRender_notInNetworkIcon( false )
			.GetCurrentEntityItemName()
			
			SIGen.NewRecipe( itemName )
			.SetLocalisedNames{ "SICFL.code-name-recipe" , localisedNames }
			.SetLocalisedDescriptions{ "SIEXHS.desc-recipe-teleporter" , localisedNames , entityData[3] }
			.SetEnergy( entityData[4] )
			.SetEnabled( true )
			.SetRecipeTypes( SIEXHS.recipeType )
			.AddCosts( SIPackers.IngredientsWithList( entityData[5] ) )
			.AddCosts( structureItem , 40 )
			.AddCosts( SIEXHS.powerItems[level] , level*200 )
			.AddCosts( SIEXHS.coreItem , level )
			.AddCosts( SIEXHS.gel7Item , level*150 )
			.AddCosts( lastItemName[typeCode] )
			.AddResults( itemName )
			.AddLastLevel( 2 )
			
			lastItemName[typeCode] = itemName
		end
	end
end