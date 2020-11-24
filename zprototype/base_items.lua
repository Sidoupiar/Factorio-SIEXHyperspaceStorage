-- ------------------------------------------------------------------------------------------------
-- ---------- 创建材料 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-teleporter-base" )

SIEXHS.coreItem = SIGen.NewItem( "main-core" ).GetCurrentEntityName()
SIEXHS.wallItem = SIGen.NewItem( "super-wall" , 25 ).GetCurrentEntityName()
SIEXHS.gel3Item = SIGen.NewItem( "gel-3" , 45 ).GetCurrentEntityName()
SIEXHS.gel7Item = SIGen.NewItem( "gel-7" , 45 ).GetCurrentEntityName()
SIEXHS.lightItem = SIGen.NewItem( "light" , 10 ).GetCurrentEntityName()

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建配方 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen

.NewRecipe( SIEXHS.coreItem )
.SetEnergy( 12 )
.SetEnabled( true )
.AddCosts( "stone" , 10 )
.AddCosts( "iron-ore" )
.AddCosts( "copper-ore" )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 0.002 , 1 , 1 , 1 ) )
.AddResults( SIPackers.SingleItemProduct( "stone" , 0.65 , 2 , 3 , 3 ) )
.SetSelfIcon( "main-core" )

.NewRecipe( SIEXHS.wallItem )
.SetEnergy( 25 )
.SetEnabled( true )
.AddCosts( "automation-science-pack" , 4 )
.AddCosts( "stone-wall" , 15 )
.AddCosts( "steel-plate" , 25 )
.AddCosts( SIEXHS.coreItem )
.AddResults( SIEXHS.wallItem , 2 )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 1 , nil , nil , 1 ) )
.SetSelfIcon( "super-wall" )

.NewRecipe( SIEXHS.gel3Item )
.SetEnergy( 3 )
.SetEnabled( true )
.SetRecipeTypes( "advanced-crafting" )
.AddCosts( "iron-plate" )
.AddCosts( SIPackers.SingleFluidIngredient( "steam" , 25 , 150 , 220 ) )
.AddCosts( SIEXHS.coreItem )
.AddResults( SIEXHS.gel3Item )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 1 , nil , nil , 1 ) )
.SetSelfIcon( "gel-3" )

.NewRecipe( SIEXHS.gel7Item )
.SetEnergy( 20 )
.SetEnabled( true )
.AddCosts( "coal" , 32 )
.AddCosts( "copper-ore" , 25 )
.AddCosts( SIEXHS.gel3Item , 15 )
.AddCosts( SIEXHS.coreItem )
.AddResults( SIEXHS.gel7Item , 5 )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 1 , nil , nil , 1 ) )
.SetSelfIcon( "gel-7" )

.NewRecipe( SIEXHS.lightItem )
.SetEnergy( 45 )
.SetEnabled( true )
.AddCosts( "wood" , 4 )
.AddCosts( SIEXHS.wallItem , 10 )
.AddCosts( SIEXHS.gel3Item , 5 )
.AddCosts( SIEXHS.gel7Item , 12 )
.AddResults( SIEXHS.lightItem , 2 )
.SetSelfIcon( "light" )