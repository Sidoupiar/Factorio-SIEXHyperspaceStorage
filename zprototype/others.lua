-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
-- ---------- 额外材料 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-others" )

local onDeath = SIGen.NewItem( "hand-on-death" ).GetCurrentEntityName()
local clover = SIGen.NewContainerLinked( "clover-machine" , nil , SITypes.linkedMode.none )
.SetProperties( 3 , 3 , 2500 , 0 , nil , nil , 999 )
.SetPic( "picture" , SIPics.NewLayer( SIGen.GetLayerFile() , 230 , 230 ).Priority( "extra-high" ).Shift( 0 , -74 ).Get() )
.GetCurrentEntityItemName()

SIGen.NewRecipe( onDeath )
.SetEnergy( 60 )
.SetEnabled( true )
.SetRecipeTypes( SIEXHS.recipeType )
.AddCosts( "steel-plate" , 15 )
.AddCosts( "transport-belt" , 50 )
.AddCosts( SIEXHS.lightItem , 25 )
.AddCosts( SIEXHS.gel7Item , 40 )
.AddCosts( SIEXHS.coreItem )
.AddResults( SIPackers.SingleItemProduct( onDeath , 1 , nil , nil , 1 ) )
.SetSelfIcon( "hand-on-death" )

.NewRecipe( clover )
.SetEnergy( 100 )
.SetEnabled( true )
.SetRecipeTypes( SIEXHS.recipeType )
.AddCosts( "wood" , 100 )
.AddCosts( "wooden-chest" , 50 )
.AddCosts( "coal" , 45 )
.AddCosts( "stone" , 120 )
.AddCosts( "iron-plate" , 35 )
.AddCosts( SIPackers.SingleFluidIngredient( "water" , 2000 , 1 , 99 ) )
.AddCosts( SIEXHS.gel7Item , 5 )
.AddCosts( SIEXHS.autoItem )
.AddCosts( SIEXHS.coreItem , 2 )
.AddResults( SIPackers.SingleItemProduct( clover , 1 , nil , nil , 1 ) )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 2 , nil , nil , 2 ) )
.SetSelfIcon( "clover-machine" )