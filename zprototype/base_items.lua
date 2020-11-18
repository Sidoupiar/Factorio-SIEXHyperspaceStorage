SIGen.NewSubGroup( "hyperspace-teleporter" )

SIEXHS.wallItem = SIGen.NewItem( "super-wall" , 25 ).GetCurrentEntityName()
SIEXHS.coreItem = SIGen.NewItem( "main-core" , 1 ).GetCurrentEntityName()

SIGen
.NewRecipe( SIEXHS.wallItem )
.SetEnergy( 25 )
.SetEnabled( true )
.AddCosts( "automation-science-pack" , 4 )
.AddCosts( "stone-wall" , 15 )
.AddCosts( "steel-plate" , 25 )
.AddResults( SIEXHS.wallItem , 2 )

.NewRecipe( SIEXHS.coreItem )
.SetEnergy( 10 )
.SetEnabled( true )
.AddCosts( "stone" , 10 )
.AddCosts( "iron-ore" , 1 )
.AddCosts( "copper-ore" , 1 )
.AddResults( SIPackers.SingleItemProduct( SIEXHS.coreItem , 0.005 , 1 , 1 , 1 ) )