-- ------------------------------------------------------------------------------------------------
-- ---------- 创建材料 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local effects =
{
	speed = function( level )
		return
		{
			[SITypes.moduleEffect.speed] = { bonus = level*1.2 } ,
			[SITypes.moduleEffect.product] = { bonus = -1.5 } ,
			[SITypes.moduleEffect.consumption] = { bonus = level*2 } ,
			[SITypes.moduleEffect.pollut] = { bonus = level*1.2 }
		}
	end ,
	product = function( level )
		return
		{
			[SITypes.moduleEffect.speed] = { bonus = -6 } ,
			[SITypes.moduleEffect.product] = { bonus = level*0.3 } ,
			[SITypes.moduleEffect.consumption] = { bonus = level*3.5 } ,
			[SITypes.moduleEffect.pollut] = { bonus = level*2 }
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
		.AddResults( SIPackers.SingleItemProduct( moduleName , 1 , nil , nil , 1 ) )
		.AddLastLevel( 5 )
	end
end