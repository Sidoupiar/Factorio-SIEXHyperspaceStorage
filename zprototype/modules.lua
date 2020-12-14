-- ------------------------------------------------------------------------------------------------
-- ---------- 创建材料 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

function Speed( level )
	return
	{
		[SITypes.moduleEffect.speed] = { bonus = level*1.2 } ,
		[SITypes.moduleEffect.product] = { bonus = -0.75 } ,
		[SITypes.moduleEffect.consumption] = { bonus = level*2 } ,
		[SITypes.moduleEffect.pollut] = { bonus = level*1.2 }
	}
end

function Product( level )
	return
	{
		[SITypes.moduleEffect.speed] = { bonus = -6 } ,
		[SITypes.moduleEffect.product] = { bonus = level*0.15 } ,
		[SITypes.moduleEffect.consumption] = { bonus = level*3.2 } ,
		[SITypes.moduleEffect.pollut] = { bonus = level*1.7 }
	}
end

SIGen.NewSubGroup( "hyperspace-module" )
.NewTypeModule( "siexhs-module-speed" )
.NewTypeModule( "siexhs-module-product" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建配方 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

for level = 1 , SIEXHS.maxLevel , 1 do
	local moduleSpeedName = SIGen.NewModule( "module-speed-mk"..level , 100 )
	.SetLevel( level )
	.SetLimitation( SIEXHS.moduleLimit , "module-limitation" )
	.SetCustomData
	{
		category = "siexhs-module-speed" ,
		effect = Speed( level )
	}
	.GetCurrentEntityName()
	
	SIGen.NewRecipe( moduleSpeedName )
	.SetEnergy( math.pow( level , 2 )*40 )
	.SetEnabled( true )
	.SetRecipeTypes( SIEXHS.recipeType )
	.AddCosts( "electronic-circuit" , level*10+5 )
	.AddCosts( "iron-gear-wheel" , level*15+20 )
	.AddCosts( SIEXHS.gel7Item , level*4+8 )
	.AddCosts( SIEXHS.autoItem )
	.AddResults( SIPackers.SingleItemProduct( moduleSpeedName , 1 , nil , nil , 1 ) )
	.AddLastLevel( 5 )
	
	local moduleProductName = SIGen.NewModule( "module-product-mk"..level , 100 )
	.SetLevel( level )
	.SetLimitation( SIEXHS.moduleLimit , "module-limitation" )
	.SetCustomData
	{
		category = "siexhs-module-product" ,
		effect = Speed( level )
	}
	.GetCurrentEntityName()
	
	local ingredient = nil
	local count = 1
	if level == 1 then
		ingredient = moduleProductName
		count = 2
	end
	
	SIGen.NewRecipe( moduleProductName )
	.SetEnergy( math.pow( level , 2 )*40 )
	.SetEnabled( true )
	.SetRecipeTypes( SIEXHS.recipeType )
	.AddCosts( "electronic-circuit" , level*10+5 )
	.AddCosts( "iron-gear-wheel" , level*15+20 )
	.AddCosts( SIEXHS.gel7Item , level*4+8 )
	.AddCosts( ingredient )
	.AddCosts( SIEXHS.autoItem )
	.AddResults( SIPackers.SingleItemProduct( moduleProductName , count , nil , nil , count ) )
	.AddLastLevel( 5 )
end

SIGen.NewSubGroup( "hyperspace-others" )
.NewRecipe( "teleporter-to-module-product-mk1" )
.SetEnergy( 800 )
.SetEnabled( true )
.SetRecipeTypes( SIEXHS.recipeType )
.AddCosts( "siexhs-item-teleporter-output-mk3" )
.AddCosts( SIEXHS.gel7Item , 80 )
.AddCosts( SIEXHS.autoItem , 5 )
.AddResults( SIPackers.SingleItemProduct( "siexhs-module-module-product-mk1" , 1 , nil , nil , 1 ) )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.autoItem , 3 , nil , nil , 3 ) )
.AddLastLevel( 5 )
.SetSelfIcon( "module-product-mk1" )