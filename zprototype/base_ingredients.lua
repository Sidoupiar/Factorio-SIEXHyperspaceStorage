SIGen.NewSubGroup( "hyperspace-teleporter" )

SIEXHS.wallItem = SIGen.NewItem( "super-wall" , 25 ).GetCurrentEntityName()
local wallRecipe = SIGen.NewRecipe( SIEXHS.wallItem )
.SetEnergy( 25 )
.AddCosts( "automation-science-pack" , 4 )
.AddCosts( "stone-wall" , 15 )
.AddCosts( "steel-plate" , 25 )
.AddResults( SIEXHS.wallItem , 2 )
.GetCurrentEntityName()


SIEXHS.ingredientsTechnology = SIGen.NewTechnology( "ingredients" )
.SetCosts( { "automation-science-pack" } , 250 )
.SetSpeed( 120 )
.AddResults( wallRecipe )
.GetCurrentEntityName()