-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local fuelType = "siexhs-electricity-power"
local list =
{
	{
		energy = "10M" ,
		size = { 3 , 2 } ,
		recipe = { { "steam-engine" , 10 } , { "assembling-machine-1" , 20 } , { "electronic-circuit" , 40 } }
	} ,
	{
		energy = "500M" ,
		size = { 3 , 2 } ,
		recipe = { { "big-electric-pole" , 45 } , { "power-switch" , 20 } , { "repair-pack" , 20 } }
	} ,
	{
		energy = "25G" ,
		size = { 3 , 2 } ,
		recipe = { { "refined-hazard-concrete" , 100 } , { "accumulator" , 25 } , { "advanced-circuit" , 60 } }
	} ,
	{
		energy = "1.25T" ,
		size = { 3, 2 } ,
		recipe = { { "steam-turbine" , 40 } , { "beacon" , 30 } , { "substation" , 65 } , { "processing-unit" , 80 } }
	} ,
	{
		energy = "62.5T" ,
		size = { 3, 2 } ,
		recipe = { { "nuclear-reactor" , 20 } , { "personal-roboport-mk2-equipment" , 50 } , { "battery-mk2-equipment" , 200 } , { "speed-module-3" , 100 } }
	}
}

SIEXHS.powerItems = {}

local function CreatePic( name )
	local path = SIGen.GetLayerFile()
	return
	{
		north = SIPics.OnAnimLayer( path.."-north-south" , 3 , 2 , nil , 0 , 16 ).Shift( 0 , -8 ).Get() ,
		east = SIPics.OnAnimLayer( path.."-east-west" , 2 , 3 ).Get() ,
		south = SIPics.OnAnimLayer( path.."-north-south" , 3 , 2 , nil , 0 , 16 ).Shift( 0 , -8 ).Get() ,
		west = SIPics.OnAnimLayer( path.."-east-west" , 2 , 3 ).Get() ,
	}
end

-- ------------------------------------------------------------------------------------------------
-- -------- 创建辅助物品 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewTypeFuel( fuelType )

-- ------------------------------------------------------------------------------------------------
-- ---- 创建物品实体配方科技 ----------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

for level = 1 , SIEXHS.maxLevel , 1 do
	local packerData = list[level]
	local energy = packerData.energy
	local size = packerData.size
	local recipe = packerData.recipe
	local technology = packerData.technology
	local recipeType = "siexhs-electricity-power-packer-mk" .. level
	
	SIGen.NewTypeRecipe( recipeType )
	
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
	.SetEnabled( true )
	.SetRecipeTypes( recipeType )
	.SetResults{ SIPackers.SingleItemProduct( itemName , 1 , nil , nil , 1 ) }
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
	.SetPic( "animation" , CreatePic( "electricity-packer-mk"..level ) )
	.GetCurrentEntityItemName()
	
	SIGen.NewRecipe( packerName )
	.SetLocalisedNames{ "SICFL.code-name-recipe" , packerLocalisedNames }
	.SetLocalisedDescriptions{ "SIEXHS.desc-recipe" , packerLocalisedNames }
	.SetEnergy( math.pow( level , 2 )*10 )
	.SetEnabled( true )
	.SetCosts( SIPackers.IngredientsWithList( recipe ) )
	.SetResults( packerName )
	.AddLastLevel( 4 )
	
	local unpackerLocalisedNames = { "SIEXHS.name-unpacker" , level }
	local unpackerName = SIGen.NewSubGroup( "hyperspace-electricity-unpacker" )
	.NewBurnerGenerator( "electricity-unpacker-mk"..level )
	.SetLocalisedNames( unpackerLocalisedNames )
	.SetLocalisedDescriptions{ "SIEXHS.desc-unpacker" }
	.SetProperties( size[1] , size[2] , size[1]*100 , 1 , energy.."W" , SIPackers.ElectricEnergySource( SITypes.electricUsagePriority.secondaryOutput ) )
	.SetCustomData{ burner = SIPackers.BurnerEnergySourceWithParameters{ fuel_category = fuelType } }
	.GetCurrentEntityItemName()
	
	SIGen.NewRecipe( unpackerName )
	.SetLocalisedNames{ "SICFL.code-name-recipe" , unpackerLocalisedNames }
	.SetLocalisedDescriptions{ "SIEXHS.desc-recipe" , unpackerLocalisedNames }
	.SetEnergy( math.pow( level , 2 )*10 )
	.SetEnabled( true )
	.SetCosts( SIPackers.IngredientsWithList( recipe ) )
	.SetResults( unpackerName )
	.AddLastLevel( 4 )
end