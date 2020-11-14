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
		ingredients = { { "splitter" , 300 } , { "filter-inserter" , 200 } , { "electric-mining-drill" , 100 } } ,
		technology = { { "logistics" , "fast-inserter" , "steel-processing" } , { "automation-science-pack" } , 500 , 90 }
	} ,
	{
		small = { 1 , 29 , 3 , 120 } ,
		normal = { 3 , 89 , 3 , 240 , { { "logistic-science-pack" , 250 } } } ,
		ingredients = { { "laser-turret" , 250 } , { "assembling-machine-2" , 100 } , { "locomotive" , 100 } , { "substation" , 100 } } ,
		technology = { { "railway" , "laser-turrets" } , { "automation-science-pack" , "logistic-science-pack" , "chemical-science-pack" } , 3000 , 180 }
	} ,
	{
		small = { 1 , 149 , 4 , 240 } ,
		normal = { 3 , 399 , 6 , 480 , { { "iron-chest" , 350 } } } ,
		ingredients = { { "express-underground-belt" , 200 } , { "fusion-reactor-equipment" , 100 } , { "effectivity-module-3" , 100 } , { "satellite" , 10 } } ,
		technology = { { "logistics-3" , "effectivity-module-3" , "fusion-reactor-equipment" , "space-science-pack" } , { "automation-science-pack" , "logistic-science-pack" , "chemical-science-pack" , "production-science-pack" , "utility-science-pack" } , 25000 , 360 }
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
	local recipeNames = {}
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
			
			table.insert( recipeNames , SIGen.NewRecipe( itemName )
			.SetLocalisedNames{ "SICFL.code-name-recipe" , localisedNames }
			.SetLocalisedDescriptions{ "SIEXHS.desc-recipe-teleporter" , localisedNames }
			.SetEnergy( entityData[4] )
			.AddCosts( SIPackers.IngredientsWithList( teleporterData.ingredients ) )
			.AddCosts( SIPackers.IngredientsWithList( entityData[5] ) )
			.AddCosts( SIEXHS.powerItems[level] , level*200 )
			.AddCosts( lastItemName )
			.AddResults( itemName )
			.AddLastLevel( 2 )
			.GetCurrentEntityName() )
			
			lastItemName = itemName
		end
	end
	
	local technologyData = teleporterData.technology
	SIGen.NewTechnology( "teleporter-mk"..level )
	.AddTechnologies{ SIEXHS.packerTechnologies[level] }
	.AddTechnologies( technologyData[1] )
	.SetCosts( technologyData[2] , technologyData[3] )
	.SetSpeed( technologyData[4] )
	.SetResults( SIPackers.RecipeModifiers( recipeNames ) )
	.AddLastLevel()
end