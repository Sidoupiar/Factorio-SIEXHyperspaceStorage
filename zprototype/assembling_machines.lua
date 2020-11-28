-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local list =
{
	{
		energy = "500KW" ,
		data = { 0.05 , 15 , 2 } ,
		recipe = { { "steam-engine" , 4 } , { "iron-gear-wheel" , 20 } , { "electronic-circuit" , 15 } }
	} ,
	{
		energy = "1MW" ,
		data = { 0.1 , 15 , 3 } ,
		recipe = { { "power-switch" , 10 } , { "assembling-machine-1" , 5 } , { "repair-pack" , 15 } }
	} ,
	{
		energy = "2MW" ,
		data = { 0.2 , 15 , 5 } ,
		recipe = { { "accumulator" , 10 } , { "assembling-machine-2" , 5 } , { "advanced-circuit" , 5 } }
	} ,
	{
		energy = "5MW" ,
		data = { 0.3 , 15 , 10 } ,
		recipe = { { "steam-turbine" , 5 } , { "assembling-machine-3" , 5 } , { "processing-unit" , 10 } }
	} ,
	{
		energy = "10MW" ,
		data = { 0.5 , 15 , 20 } ,
		recipe = { { "nuclear-reactor" , 2 } , { "battery-mk2-equipment" , 10 } , { "speed-module-3" , 5 } }
	}
}

local function InputBox( pos )
	return SIPackers.FluidBox( 10 , SIPackers.FluidBoxConnection( pos , SITypes.fluidBoxConnectionType.inAndOut ) , -2 , SITypes.fluidBoxProductionType.input )
end

local function OutpuBox( pos )
	return SIPackers.FluidBox( 10 , SIPackers.FluidBoxConnection( pos , SITypes.fluidBoxConnectionType.inAndOut ) , 2 , SITypes.fluidBoxProductionType.output )
end

local function CreatePic()
	local path = SIGen.GetLayerFile()
	local layer = SIPics.OnAnimLayer( path.."-four" , 3 , 3 ).Get()
	return
	{
		north = layer ,
		south = layer ,
		east = layer ,
		west = layer
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
	.SetLevel( "siexhs-assembling-machine" , SIEXHS.maxLevel )
	.SetFluidBoxes{ InputBox{ 2 , 0 } , InputBox{ 1 , 2 } , InputBox{ 1 , -2 } , OutpuBox{ -2 , 0 } , OutpuBox{ -1 , 2 } , OutpuBox{ -1 , -2 } }
	.SetRecipeTypes{ "basic-crafting" , "crafting" , "advanced-crafting" , "smelting" , "chemistry" , "crafting-with-fluid" , "oil-processing" , SIEXHS.recipeType }
	.SetPluginTypes{ SITypes.moduleEffect.speed , SITypes.moduleEffect.product , SITypes.moduleEffect.consumption , SITypes.moduleEffect.pollut }
	.SetPic( "animation" , CreatePic() )
	.GetCurrentEntityItemName()
	
	SIGen.NewRecipe( machineName )
	.SetLocalisedNames{ "SICFL.code-name-recipe" , localisedNames }
	.SetLocalisedDescriptions{ "SIEXHS.desc-recipe" , localisedNames }
	.SetEnergy( math.pow( level , 2 )*10 )
	.SetEnabled( true )
	.AddCosts( SIPackers.IngredientsWithList( recipe ) )
	.AddCosts( "stone-brick" , level*5+5 )
	.AddCosts( SIEXHS.autoItem , level*2+3 )
	.AddResults( machineName )
	.AddLastLevel( 3 )
end