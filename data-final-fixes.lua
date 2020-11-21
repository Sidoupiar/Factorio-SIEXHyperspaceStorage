-- ------------------------------------------------------------------------------------------------
-- --- 给组装机一增加流体盒子 ---------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

local machine = SIGen.GetData( SITypes.entity.machine , "assembling-machine-1" )
if not table.Has( machine.crafting_categories , "advanced-crafting" ) then table.insert( machine.crafting_categories , "advanced-crafting" ) end
if not machine.fluid_boxes then
	local machine2 = SIGen.GetData( SITypes.entity.machine , "assembling-machine-2" )
	machine.fluid_boxes = machine2.fluid_boxes
end