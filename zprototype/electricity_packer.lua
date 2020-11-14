-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local fuelType = "siexhs-electricity-power"
local recipeType = "siexhs-electricity-power-packer"
local list =
{
	{
		energy = "10M" ,
		size = { 3 , 2 } ,
		recipe = { { "steam-engine" , 10 } , { "assembling-machine-1" , 20 } , { "electronic-circuit" , 60 } } ,
		technology = { { "automation" , SIEXHS.ingredientsTechnology } , { "automation-science-pack" } , 50 , 15 }
	} ,
	{
		energy = "500M" ,
		size = { 3 , 2 } ,
		recipe = { { "big-electric-pole" , 45 } , { "accumulator" , 20 } , { "advanced-circuit" , 80 } } ,
		technology = { { "electric-energy-accumulators" , "advanced-electronics" } , { "automation-science-pack" , "logistic-science-pack" , "chemical-science-pack" } , 350 , 30 }
	} ,
	{
		energy = "25G" ,
		size = { 3 , 2 } ,
		recipe = { { "nuclear-reactor" , 10 } , { "beacon" , 20 } , { "substation" , 25 } , { "processing-unit" , 125 } } ,
		technology = { { "nuclear-power" , "effect-transmission" , "electric-energy-distribution-2" } , { "automation-science-pack" , "logistic-science-pack" , "chemical-science-pack" , "production-science-pack" , "utility-science-pack" } , 750 , 60 }
	}
}

SIEXHS.powerItems = {}
SIEXHS.packerTechnologies = {}

-- ------------------------------------------------------------------------------------------------
-- -------- 创建辅助物品 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewTypeFuel( fuelType ).NewTypeRecipe( recipeType )

-- ------------------------------------------------------------------------------------------------
-- ---- 创建物品实体配方科技 ----------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

for level = 1 , SIEXHS.maxLevel , 1 do
	local packerData = list[level]
	local energy = packerData.energy
	local size = packerData.size
	local recipe = packerData.recipe
	local technology = packerData.technology
	
	local itemName = SIGen.NewSubGroup( "hyperspace-electricity-item" )
	.NewItem( "electricity-power-mk"..level , 100 )
	.SetLocalisedNames{ "SIEXHS.name-power" , level }
	.SetLocalisedDescriptions{ "SIEXHS.desc-power" }
	.SetEnergy( energy.."J" , fuelType )
	.GetCurrentEntityName()
	
	local itemRecipeName = SIGen.NewRecipe( itemName )
	.SetLocalisedNames{ "SIEXHS.name-power-recipe" , level }
	.SetLocalisedDescriptions{ "SIEXHS.desc-power-recipe" }
	.SetEnergy( 1 )
	.SetRecipeTypes( recipeType )
	.SetResults{ SIPackers.SingleItemProduct( itemName , 1 , nil , nil , 1 ) }
	.SetCustomData{ enabled = true }
	.GetCurrentEntityName()
	table.insert( SIEXHS.powerItems , itemName )
	
	local packerLocalisedNames = { "SIEXHS.name-packer" , level }
	local packerName = SIGen.NewSubGroup( "hyperspace-electricity-packer" )
	.NewMachine( "electricity-packer-mk"..level )
	.SetLocalisedNames( packerLocalisedNames )
	.SetLocalisedDescriptions{ "SIEXHS.desc-packer" }
	.SetProperties( size[1] , size[2] , size[1]*100 , 1 , energy.."W" , SIPackers.ElectricEnergySource() , 1 )
	.SetRecipeTypes( recipeType )
	.SetMainRecipe( itemRecipeName )
	.GetCurrentEntityItemName()
	
	local packerRecipeName = SIGen.NewRecipe( packerName )
	.SetLocalisedNames{ "SICFL.code-name-recipe" , packerLocalisedNames }
	.SetLocalisedDescriptions{ "SIEXHS.desc-recipe" , packerLocalisedNames }
	.SetEnergy( math.pow( level , 2 )*5 )
	.SetCosts( SIPackers.IngredientsWithList( recipe ) )
	.SetResults( packerName )
	.AddLastLevel( 2 )
	.GetCurrentEntityName()
	
	local unpackerLocalisedNames = { "SIEXHS.name-unpacker" , level }
	local unpackerName = SIGen.NewSubGroup( "hyperspace-electricity-unpacker" )
	.NewBurnerGenerator( "electricity-unpacker-mk"..level )
	.SetLocalisedNames( unpackerLocalisedNames )
	.SetLocalisedDescriptions{ "SIEXHS.desc-unpacker" }
	.SetProperties( size[1] , size[2] , size[1]*100 , 1 , energy.."W" , SIPackers.ElectricEnergySource( SITypes.electricUsagePriority.secondaryOutput ) )
	.SetCustomData{ burner = SIPackers.BurnerEnergySourceWithParameters{ fuel_category = fuelType } }
	.GetCurrentEntityItemName()
	
	local unpackerRecipeName = SIGen.NewRecipe( unpackerName )
	.SetLocalisedNames{ "SICFL.code-name-recipe" , unpackerLocalisedNames }
	.SetLocalisedDescriptions{ "SIEXHS.desc-recipe" , unpackerLocalisedNames }
	.SetEnergy( math.pow( level , 2 )*5 )
	.SetCosts( SIPackers.IngredientsWithList( recipe ) )
	.SetResults( unpackerName )
	.AddLastLevel( 2 )
	.GetCurrentEntityName()
	
	table.insert( SIEXHS.packerTechnologies , SIGen.NewTechnology( "electricity-transport-mk"..level )
	.SetTechnologies( technology[1] )
	.SetCosts( technology[2] , technology[3] )
	.SetSpeed( technology[4] )
	.AddResults( packerRecipeName )
	.AddResults( unpackerRecipeName )
	.AddLastLevel()
	.GetCurrentEntityName() )
end