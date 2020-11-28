-- ------------------------------------------------------------------------------------------------
-- ---------- 创建材料 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-resource" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建配方 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

.NewRecipe( "resource-wood" )
.SetEnergy( 3500 )
.SetEnabled( true )
.SetRecipeTypes( SIEXHS.recipeType )
.AddCosts( "wood" , 2000 )
.AddCosts( "stone" , 60 )
.AddCosts( SIPackers.SingleFluidIngredient( "water" , 1200 , 1 , 99 ) )
.AddCosts( SIEXHS.gel3Item , 12 )
.AddCosts( SIEXHS.coreItem )
.AddResults( "wood" , 2460 )
.AddResults( SIPackers.SingleFluidProduct( "water" , 850 ) )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 0.85 , 1 , 1 , 1 ) )
.SetSelfIcon( "resource-wood" )

.NewRecipe( "resource-fish" )
.SetEnergy( 4100 )
.SetEnabled( true )
.SetRecipeTypes( SIEXHS.recipeType )
.AddCosts( "raw-fish" , 300 )
.AddCosts( "wood" , 70 )
.AddCosts( "stone" , 25 )
.AddCosts( SIPackers.SingleFluidIngredient( "water" , 2000 , 1 , 99 ) )
.AddCosts( SIEXHS.gel3Item , 12 )
.AddCosts( SIEXHS.coreItem )
.AddResults( "raw-fish" , 365 )
.AddResults( SIPackers.SingleFluidProduct( "water" , 1700 ) )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 0.85 , 1 , 1 , 1 ) )
.SetSelfIcon( "resource-fish" )

.NewRecipe( "resource-water" )
.SetEnergy( 30 )
.SetEnabled( true )
.SetRecipeTypes( SIEXHS.recipeType )
.AddCosts( "wood" , 4 )
.AddCosts( SIEXHS.coreItem )
.AddResults( SIPackers.SingleFluidProduct( "water" , 5200 ) )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 0.85 , 1 , 1 , 1 ) )
.SetSelfIcon( "resource-water" )

.NewRecipe( "resource-oil" )
.SetEnergy( 720 )
.SetEnabled( true )
.SetRecipeTypes( SIEXHS.recipeType )
.AddCosts( "wood" , 210 )
.AddCosts( "raw-fish" , 85 )
.AddCosts( SIEXHS.gel3Item , 18 )
.AddCosts( SIEXHS.gel7Item , 5 )
.AddCosts( SIEXHS.coreItem )
.AddResults( SIPackers.SingleFluidProduct( "crude-oil" , 6200 ) )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 0.62 , 1 , 1 , 1 ) )
.SetSelfIcon( "resource-oil" )