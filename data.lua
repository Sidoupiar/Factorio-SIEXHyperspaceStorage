load()

-- ------------------------------------------------------------------------------------------------
-- ----------- 初始化 -----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen
.Init( SIEXHS )
.NewGroup( "extensions" )

needlist( "zprototype" , "view" , "bases" , "resources" , "modules" , "assembling_machines" , "electricity_packers" , "teleporters" , "others" )

SIGen.Finish()

-- ------------------------------------------------------------------------------------------------
-- ------ 专用插件添加限制 ------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

for name , recipe in pairs( SIGen.GetList( SITypes.recipe ) ) do
	if name:sub( 1 , 6 ) == "siexhs" or recipe.category == SIEXHS.recipeType then table.insert( SIEXHS.moduleLimit , name ) end
end