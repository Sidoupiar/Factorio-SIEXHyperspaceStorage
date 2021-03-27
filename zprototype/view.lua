-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-icons" )
.NewItem( "container" , 1000 ).AddFlags( SIFlags.itemFlags.hidden )
.NewItem( "teleporter" , 1000 ).AddFlags( SIFlags.itemFlags.hidden )
.NewInput( "container" , "SHIFT + C" )
.NewInput( "teleporter" , "SHIFT + T" )
.NewSubGroup( "hyperspace-flags" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建界面 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewStyle( "container-view" ,
{
	type = "frame_style" ,
	parent = "frame" ,
	minimal_width = 100 ,
	minimal_height = 100 ,
	maximal_height = 700
} )
.NewStyle( "teleporter-view" ,
{
	type = "frame_style" ,
	parent = "frame" ,
	minimal_width = 100 ,
	minimal_height = 100 ,
	maximal_height = 700
} )
.NewStyle( "list" ,
{
	type = "table_style" ,
	cell_spacing = 2 ,
	horizontal_spacing = 1 ,
	vertical_spacing = 1
} )
.NewStyle( "list-icon" ,
{
	type = "button_style" ,
	parent = "button" ,
	
	top_padding = 0 ,
	right_padding = 0 ,
	bottom_padding = 0 ,
	left_padding = 0 ,
	
	minimal_width = 32 ,
	minimal_height = 32
} )
.NewStyle( "label-icon" ,
{
	type = "label_style" ,
	width = 32 ,
	horizontal_align = "center"
} )
.NewStyle( "label-long" ,
{
	type = "label_style" ,
	width = 219 ,
	horizontal_align = "center"
} )
.NewStyle( "label-text" ,
{
	type = "label_style" ,
	width = 250 ,
	horizontal_align = "left"
} )
.NewStyle( "textfield-long" ,
{
	type = "textbox_style" ,
	width = 219
} )
.NewStyle( "button-gray" , SIStyles.ColorButton( 0 , SIStyles.grayDirt ) )
.NewStyle( "button-green" , SIStyles.ColorButton( 68 , SIStyles.greenDirt ) )
.NewStyle( "button-red" , SIStyles.ColorButton( 136 , SIStyles.redDirt ) )