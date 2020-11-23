-- ------------------------------------------------------------------------------------------------
-- ---------- 基础数据 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

SIGen.NewSubGroup( "hyperspace-teleporter" )
.NewItem( "container" , 1000 ).AddFlags( SIFlags.itemFlags.hidden )
.NewItem( "teleporter" , 1000 ).AddFlags( SIFlags.itemFlags.hidden )
.NewInput( "container" , "SHIFT + C" )
.NewInput( "teleporter" , "SHIFT + T" )

-- ------------------------------------------------------------------------------------------------
-- ---------- 创建界面 ----------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local view =
{
	["siexhs-container-view"] =
	{
		type = "frame_style" ,
		parent = "frame" ,
		minimal_width = 100 ,
		minimal_height = 100 ,
		maximal_height = 700
	} ,
	["siexhs-teleporter-view"] =
	{
		type = "frame_style" ,
		parent = "frame" ,
		minimal_width = 100 ,
		minimal_height = 100 ,
		maximal_height = 700
	} ,
	["siexhs-list"] =
	{
		type = "table_style" ,
		cell_spacing = 2 ,
		horizontal_spacing = 1 ,
		vertical_spacing = 1
	} ,
	["siexhs-list-icon"] =
	{
		type = "button_style" ,
		parent = "button" ,
		
		top_padding = 0 ,
		right_padding = 0 ,
		bottom_padding = 0 ,
		left_padding = 0 ,
		
		minimal_width = 32 ,
		minimal_height = 32
	} ,
	["siexhs-label-icon"] =
	{
		type = "label_style" ,
		width = 32 ,
		horizontal_align = "center"
	} ,
	["siexhs-label-long"] =
	{
		type = "label_style" ,
		width = 219 ,
		horizontal_align = "center"
	} ,
	["siexhs-label-text"] =
	{
		type = "label_style" ,
		width = 250 ,
		horizontal_align = "left"
	} ,
	["siexhs-textfield-long"] =
	{
		type = "textbox_style" ,
		width = 219
	}
}

local function ColorButton( location , dirt )
	return
	{
		type = "button_style" ,
		font = "default-semibold" ,
		horizontal_align = "center" ,
		vertical_align = "center" ,
		icon_horizontal_align = "center" ,
		top_padding = 0 ,
		bottom_padding = 0 ,
		left_padding = 8 ,
		right_padding = 8 ,
		minimal_width = 108 ,
		minimal_height = 28 ,
		clicked_vertical_offset = 1 ,
		default_font_color = SIColors.fontColor.black ,
		hovered_font_color = SIColors.fontColor.black ,
		clicked_font_color = SIColors.fontColor.black ,
		disabled_font_color = { 0.7 , 0.7 , 0.7 } ,
		selected_font_color = SIColors.fontColor.black ,
		selected_hovered_font_color = SIColors.fontColor.black ,
		selected_clicked_font_color = SIColors.fontColor.black ,
		strikethrough_color = { 0.5 , 0.5 , 0.5 } ,
		pie_progress_color = { 1 , 1 , 1 } ,
		default_graphical_set = { base = { position = { location , 17 } , corner_size = 8 } , shadow = SIStyles.defaultDirt } ,
		hovered_graphical_set = { base = { position = { location+34 , 17 } , corner_size = 8 } , shadow = SIStyles.defaultDirt , glow = dirt } ,
		clicked_graphical_set = { base = { position = { location+51 , 17 } , corner_size = 8 } , shadow = SIStyles.defaultDirt } ,
		disabled_graphical_set = { base = { position = { location+17 , 17 } , corner_size = 8 } , shadow = SIStyles.defaultDirt } ,
		selected_graphical_set = { base = { position = { 225 , 17 } , corner_size = 8 } , shadow = SIStyles.defaultDirt } ,
		selected_hovered_graphical_set = { base = { position = { 369 , 17 } , corner_size = 8 } , shadow = SIStyles.defaultDirt } ,
		selected_clicked_graphical_set = { base = { position = { 352 , 17 } , corner_size = 8 } , shadow = SIStyles.defaultDirt } ,
		left_click_sound = { { filename = "__core__/sound/gui-click.ogg" ,  volume = 1 } }
	}
end

view["siexhs-button-gray"] = ColorButton( 0 , SIStyles.grayDirt )
view["siexhs-button-green"] = ColorButton( 68 , SIStyles.greenDirt )
view["siexhs-button-red"] = ColorButton( 136 , SIStyles.redDirt )

for k , v in pairs( view ) do data.raw["gui-style"]["default"][k] = v end