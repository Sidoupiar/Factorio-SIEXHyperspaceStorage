-- ------------------------------------------------------------------------------------------------
-- ---------- 创建材料 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local effects =
{
	speed = function( level )
		return
		{
			[SITypes.moduleEffect.speed] = { bonus = level } ,
			[SITypes.moduleEffect.product] = { bonus = -1 } ,
			[SITypes.moduleEffect.consumption] = { bonus = level*2.5 } ,
			[SITypes.moduleEffect.pollut] = { bonus = level*1.5 }
		}
	end ,
	product = function( level )
		return
		{
			[SITypes.moduleEffect.speed] = { bonus = -5 } ,
			[SITypes.moduleEffect.product] = { bonus = level*0.2 } ,
			[SITypes.moduleEffect.consumption] = { bonus = level*4 } ,
			[SITypes.moduleEffect.pollut] = { bonus = level*3 }
		}
	end
}
SIGen.NewSubGroup( "hyperspace-module" )
.NewTypeModule( "siexhs-module-speed" )
.NewTypeModule( "siexhs-module-product" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建配方 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

for level = 1 , SIEXHS.maxLevel , 1 do
	for i , moduleType in pairs{ "speed" , "product" } do
		local moduleName = SIGen.NewModule( "module-"..moduleType.."-mk"..level , 100 )
		.SetLevel( level )
		.SetLimitation( SIEXHS.moduleLimit , "module-limitation" )
		.SetCustomData
		{
			category = "siexhs-module-" .. moduleType ,
			effect = effects[moduleType]( level )
		}
		.GetCurrentEntityName()
		
		SIGen.NewRecipe( moduleName )
		.SetEnergy( math.pow( level , 2 )*40 )
		.SetEnabled( true )
		.SetRecipeTypes( SIEXHS.recipeType )
		.AddCosts( "electronic-circuit" , level*10+5 )
		.AddCosts( "iron-gear-wheel" , level*15+20 )
		.AddCosts( SIEXHS.gel7Item , level*4+8 )
		.AddCosts( SIEXHS.autoItem )
		.AddResults( moduleName )
		.AddLastLevel( 5 )
	end
end