-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local list =
{
	{
		energy = "500KW" ,
		data = { 0.1 , 15 , 1 } ,
		recipe = { { "steam-engine" , 4 } , { "assembling-machine-1" , 3 } , { "electronic-circuit" , 15 } }
	} ,
	{
		energy = "1MW" ,
		data = { 0.2 , 15 , 2 } ,
		recipe = { { "power-switch" , 10 } , { "assembling-machine-2" , 3 } , { "repair-pack" , 15 } }
	} ,
	{
		energy = "2MW" ,
		data = { 0.3 , 15 , 5 } ,
		recipe = { { "accumulator" , 10 } , { "assembling-machine-3" , 3 } , { "advanced-circuit" , 5 } }
	} ,
	{
		energy = "5MW" ,
		data = { 0.5 , 15 , 10 } ,
		recipe = { { "steam-turbine" , 5 } , { "substation" , 10 } , { "processing-unit" , 10 } }
	} ,
	{
		energy = "10MW" ,
		data = { 0.8 , 15 , 20 } ,
		recipe = { { "nuclear-reactor" , 2 } , { "battery-mk2-equipment" , 10 } , { "speed-module-3" , 5 } }
	}
}

local function CreatePic( name )
	local path = SIGen.GetLayerFile()
	return
	{
		north = SIPics.OnAnimLayer( path.."-north-south" , 3 , 2 ).Get() ,
		south = SIPics.Get() ,
		east = SIPics.OnAnimLayer( path.."-east-west" , 2 , 3 ).Get() ,
		west = SIPics.Get() ,
	}
end

-- ------------------------------------------------------------------------------------------------
-- -------- 创建辅助物品 --------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-assembling-machines" )

-- ------------------------------------------------------------------------------------------------
-- ---- 创建物品实体配方科技 ----------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

for level = 1 , SIEXHS.maxLevel , 1 do
	local machineData = list[level]
	local energy = machineData.energy
	local data = machineData.data
	local recipe = machineData.recipe
	
	local localisedNames = { "SIEXHS.name-machine" , level }
	local machineName = SIGen.NewMachine( "assembling-machine-mk"..level )
	.SetLocalisedNames( localisedNames )
	.SetLocalisedDescriptions{ "SIEXHS.desc-machine" }
	.SetProperties( 3 , 3 , 450 , data[1] , energy , SIPackers.ElectricEnergySource() , data[2] )
	.SetPluginData( data[3] , { 0 , 0.9 } )
	.SetFluidBox( 10 , SIPackers.FluidBoxConnection( { { 1 , 0 } , { -1 , 0 } , { 0 , 1 } , { 0 , -1 } } , SITypes.fluidBoxConnectionType.inAndOut ) )
	.SetRecipeTypes{ "crafting" , "advanced-crafting" , "fluid-crafting" , SIEXHS.recipeType }
	.SetPic( "animation" , CreatePic( "assembling-machine-mk"..level ) 
	.GetCurrentEntityItemName()
	
	SIGen.NewRecipe( machineName )
	.SetLocalisedNames{ "SICFL.code-name-recipe" , localisedNames }
	.SetLocalisedDescriptions{ "SIEXHS.desc-recipe" , localisedNames }
	.SetEnergy( math.pow( level , 2 )*10 )
	.SetEnabled( true )
	.SetCosts( SIPackers.IngredientsWithList( recipe ) )
	.SetCosts( SIEXHS.autoItem , level*2+3 )
	.SetResults( machineName )
	.AddLastLevel( 2 )
end