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

-- ------------------------------------------------------------------------------------------------
-- ---------- 添加成就 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

data:extend
{
	{
		type = "build-entity-achievement" ,
		name = "siexhs-achievement-got-grass" ,
		icon = "__SIEXHyperspaceStorage__/zpic/achievement/got-grass.png" ,
		icon_size = 128 ,
		to_build = "siexhs-container-clover-machine" ,
		order = "si-1"
	} ,
	{
		type = "build-entity-achievement" ,
		name = "siexhs-achievement-its-over" ,
		icon = "__SIEXHyperspaceStorage__/zpic/achievement/its-over.png" ,
		icon_size = 128 ,
		to_build = "siexhs-container-teleporter-input-mk5" ,
		order = "si-2"
	}
}