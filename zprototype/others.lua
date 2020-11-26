-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------------
-- ---------- 额外材料 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-teleporter-others" )

local onDeath = SIGen.NewItem( "hand-on-death" ).GetCurrentEntityName()

SIGen.NewRecipe( onDeath )
.SetEnergy( 30 )
.SetEnabled( true )
.AddCosts( "steel-plate" , 15 )
.AddCosts( "transport-belt" , 50 )
.AddCosts( SIEXHS.lightItem , 25 )
.AddCosts( SIEXHS.gel7Item , 40 )
.AddCosts( SIEXHS.coreItem )
.AddResults( SIPackers.SingleItemProduct( onDeath , 1 , nil , nil , 1 ) )
.SetSelfIcon( "hand-on-death" )